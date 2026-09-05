#!/usr/bin/env python3
"""Update pinned casks from stable GitHub releases using only the standard library."""

import hashlib
import json
import os
from pathlib import Path
import re
import sys
from urllib.request import Request, urlopen

ROOT = Path(__file__).resolve().parents[1]
APPS = {"nes-wallpaper": "NES-Wallpaper", "constellation": "Constellation"}
VERSION = re.compile(r"v(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)")


def version_tuple(tag):
    match = VERSION.fullmatch(tag)
    if not match:
        raise ValueError(f"Unsupported stable release tag: {tag!r}; expected vMAJOR.MINOR.PATCH")
    return tuple(map(int, match.groups()))


def select_release(releases):
    stable = [r for r in releases if not r['draft'] and not r['prerelease']]
    if not stable:
        raise ValueError("No stable releases found")
    return max(stable, key=lambda r: version_tuple(r['tag_name']))


def get_releases(repo):
    releases = []
    page = 1
    while True:
        request = Request(f"https://api.github.com/repos/WolffTech/{repo}/releases?per_page=100&page={page}",
                          headers={"Accept": "application/vnd.github+json",
                                   "X-GitHub-Api-Version": "2022-11-28"})
        token = os.environ.get("GH_TOKEN") or os.environ.get("GITHUB_TOKEN")
        if token:
            request.add_header("Authorization", f"Bearer {token}")
        with urlopen(request, timeout=60) as response:
            batch = json.load(response)
        releases.extend(batch)
        if len(batch) < 100:
            return releases
        page += 1


def artifact_url(repo, prefix, release):
    tag = release['tag_name']
    version_tuple(tag)
    name = f"{prefix}-{tag[1:]}.dmg"
    matches = [a for a in release['assets'] if a['name'] == name]
    if len(matches) != 1:
        raise ValueError(f"{repo} {tag}: expected exactly one release asset {name}, found {len(matches)}")
    expected = f"https://github.com/WolffTech/{repo}/releases/download/{tag}/{name}"
    if matches[0]['browser_download_url'] != expected:
        raise ValueError(f"{repo} {tag}: unexpected download URL for {name}")
    return expected


def checksum(url):
    # Never forward the API token to release downloads or their redirect targets.
    digest = hashlib.sha256()
    with urlopen(url, timeout=60) as response:
        while chunk := response.read(1024 * 1024):
            digest.update(chunk)
    return digest.hexdigest()


def updated_recipe(recipe, repo, prefix, releases, download=checksum):
    release = select_release(releases)
    url = artifact_url(repo, prefix, release)
    version = release['tag_name'][1:]
    current = re.findall(r'^  version "([^"]+)"$', recipe, re.MULTILINE)
    hashes = re.findall(r'^  sha256 "([0-9a-f]{64})"$', recipe, re.MULTILINE)
    if len(current) != 1 or len(hashes) != 1:
        raise ValueError(f"{repo}: expected one literal version and SHA-256")
    if version_tuple('v' + version) < version_tuple('v' + current[0]):
        raise ValueError(f"{repo}: refusing downgrade from {current[0]} to {version}")
    digest = download(url)
    if not re.fullmatch(r'[0-9a-f]{64}', digest):
        raise ValueError(f"{repo}: invalid SHA-256")
    if version == current[0] and digest != hashes[0]:
        raise ValueError(f"{repo} {version}: release artifact changed without a version bump; review manually")
    recipe = re.sub(r'^  version "[^"]+"$', f'  version "{version}"', recipe, flags=re.MULTILINE)
    return re.sub(r'^  sha256 "[0-9a-f]{64}"$', f'  sha256 "{digest}"', recipe, flags=re.MULTILINE)


def main():
    pending = []
    for repo, prefix in APPS.items():
        path = ROOT / 'Casks' / f'{repo}.rb'
        original = path.read_text()
        updated = updated_recipe(original, repo, prefix, get_releases(repo))
        if updated != original:
            pending.append((path, updated))
        else:
            print(f'{repo}: current')
    # Validate both downloads before writing either recipe.
    for path, updated in pending:
        path.write_text(updated)
        print(f'{path.name}: updated')


if __name__ == '__main__':
    try:
        main()
    except Exception as error:
        print(f'Update failed: {error}', file=sys.stderr)
        sys.exit(1)
