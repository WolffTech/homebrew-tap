import importlib.util
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

spec = importlib.util.spec_from_file_location('updater', Path(__file__).resolve().parents[1] / 'scripts/update_casks.py')
u = importlib.util.module_from_spec(spec)
spec.loader.exec_module(u)


def release(tag, **flags):
    result = dict(tag_name=tag, draft=False, prerelease=False, assets=[{
        'name': f'NES-Wallpaper-{tag[1:]}.dmg',
        'browser_download_url': f'https://github.com/WolffTech/nes-wallpaper/releases/download/{tag}/NES-Wallpaper-{tag[1:]}.dmg',
    }])
    return {**result, **flags}


class UpdaterTests(unittest.TestCase):
    recipe = 'cask "nes-wallpaper" do\n  version "1.2.0"\n  sha256 "' + 'a' * 64 + '"\nend\n'

    def update(self, releases, recipe=None, digest='b' * 64):
        return u.updated_recipe(recipe or self.recipe, 'nes-wallpaper', 'NES-Wallpaper', releases, lambda _: digest)

    def test_numeric_selection_ignores_drafts_and_prereleases(self):
        releases = [release('v1.9.0'), release('v1.10.0'),
                    release('v9.0.0', draft=True), release('v10.0.0-beta', prerelease=True)]
        self.assertEqual(u.select_release(releases)['tag_name'], 'v1.10.0')

    def test_no_stable_release(self):
        with self.assertRaisesRegex(ValueError, 'No stable'):
            u.select_release([release('v2.0.0', prerelease=True)])

    def test_missing_asset_in_newest_does_not_fall_back(self):
        with self.assertRaisesRegex(ValueError, 'NES-Wallpaper-1.3.0.dmg'):
            self.update([release('v1.2.0'), release('v1.3.0', assets=[])])

    def test_exact_asset_and_url(self):
        r = release('v1.3.0')
        r['assets'].insert(0, dict(name='appcast.xml', browser_download_url='https://example.com/feed'))
        self.assertTrue(u.artifact_url('nes-wallpaper', 'NES-Wallpaper', r).endswith('/NES-Wallpaper-1.3.0.dmg'))
        r['assets'][1]['browser_download_url'] = 'https://example.com/app.dmg'
        with self.assertRaisesRegex(ValueError, 'unexpected download URL'):
            self.update([r])

    def test_repeat_run_is_byte_identical(self):
        updated = self.update([release('v1.3.0')])
        self.assertIn('version "1.3.0"', updated)
        self.assertIn('sha256 "' + 'b' * 64 + '"', updated)
        self.assertEqual(self.update([release('v1.3.0')], updated), updated)

    def test_current_is_unchanged(self):
        self.assertEqual(self.update([release('v1.2.0')], digest='a' * 64), self.recipe)

    def test_replaced_asset_requires_manual_review(self):
        with self.assertRaisesRegex(ValueError, 'without a version bump'):
            self.update([release('v1.2.0')])

    def test_downgrade_and_malformed_tag_rejected(self):
        for tag in ['v1.1.0', 'v1.3.0-pre', 'v1.3.0"']:
            with self.subTest(tag=tag), self.assertRaises(ValueError):
                self.update([release(tag)])

    def test_checksum_uses_downloaded_bytes(self):
        with tempfile.TemporaryDirectory() as directory:
            asset = Path(directory) / 'artifact'
            asset.write_bytes(b'abc')
            self.assertEqual(u.checksum(asset.as_uri()), 'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad')

    def test_no_partial_writes_on_failure(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / 'Casks').mkdir()
            for repo in u.APPS:
                (root / 'Casks' / f'{repo}.rb').write_text(self.recipe)
            with patch.object(u, 'ROOT', root), patch.object(u, 'get_releases', return_value=[]), \
                    patch.object(u, 'updated_recipe', side_effect=['changed', ValueError('missing asset')]):
                with self.assertRaises(ValueError):
                    u.main()
            self.assertEqual((root / 'Casks/nes-wallpaper.rb').read_text(), self.recipe)


if __name__ == '__main__':
    unittest.main()
