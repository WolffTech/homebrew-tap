# Wolff.Tech Homebrew tap

Desktop applications from Wolff.Tech.

## Install

With [Homebrew](https://brew.sh) installed:

```sh
brew install --cask wolfftech/tap/nes-wallpaper
brew install --cask wolfftech/tap/constellation
```

| Application | Requirements |
| --- | --- |
| [NES Wallpaper](https://github.com/WolffTech/nes-wallpaper) | Apple silicon, macOS 14 or later |
| [Constellation](https://github.com/WolffTech/constellation) | Apple silicon, macOS 15 or later |

Open the apps from `/Applications`. Install NES Wallpaper's optional screensaver through **Settings → General**.

## Updates

Both apps update themselves through Sparkle. Homebrew also upgrades them when the installed app is older than the cask version:

```sh
brew update
brew upgrade --cask wolfftech/tap/nes-wallpaper wolfftech/tap/constellation
```

## Uninstall and optional cleanup

Quit the app first. For NES Wallpaper, disable **Launch at Login** in its settings and select another screensaver if needed.

```sh
brew uninstall --cask wolfftech/tap/nes-wallpaper
brew uninstall --cask wolfftech/tap/constellation
```

Uninstall preserves user data. Add `--zap` to remove the preferences and application data listed in the cask, including NES Wallpaper's separately installed screensaver. ROMs, movie folders, and Constellation's Keychain credentials remain.
