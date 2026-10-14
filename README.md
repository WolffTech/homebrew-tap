# Wolff.Tech Homebrew tap

Desktop applications from Wolff.Tech.

## Install

With [Homebrew](https://brew.sh) installed:

```sh
brew install --cask wolfftech/tap/nes-wallpaper
brew install --cask wolfftech/tap/constellation
brew install --cask wolfftech/tap/barometry
```

| Application | Requirements |
| --- | --- |
| [NES Wallpaper](https://github.com/WolffTech/nes-wallpaper) | Apple silicon, macOS 14 or later |
| [Constellation](https://github.com/WolffTech/constellation) | Apple silicon, macOS 15 or later |
| [Barometry](https://github.com/WolffTech/barometry) | Apple silicon, macOS 26 or later |

Open the apps from `/Applications`. Barometry runs in the menu bar and has no Dock icon. Install NES Wallpaper's optional screensaver through **Settings → General**.

## Updates

The apps update themselves through Sparkle. Homebrew also upgrades them when the installed app is older than the cask version:

```sh
brew update
brew upgrade --cask wolfftech/tap/nes-wallpaper wolfftech/tap/constellation wolfftech/tap/barometry
```

## Uninstall and optional cleanup

Quit the app first. For NES Wallpaper and Barometry, disable **Launch at Login** in their settings. For NES Wallpaper, also select another screensaver if needed.

```sh
brew uninstall --cask wolfftech/tap/nes-wallpaper
brew uninstall --cask wolfftech/tap/constellation
brew uninstall --cask wolfftech/tap/barometry
```

Uninstall preserves user data. Add `--zap` to remove the preferences and application data listed in the cask, including NES Wallpaper's separately installed screensaver. ROMs, movie folders, and Constellation's Keychain credentials remain.
