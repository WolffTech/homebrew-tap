cask "nes-wallpaper" do
  version "1.3.0"
  sha256 "a2eddfb025e4b792f0d7826d7ea8b692308739b1df54d9dbbf1b951e45dca69f"

  url "https://github.com/WolffTech/nes-wallpaper/releases/download/v#{version}/NES-Wallpaper-#{version}.dmg"
  name "NES Wallpaper"
  desc "Animated NES gameplay wallpaper and companion screensaver"
  homepage "https://github.com/WolffTech/nes-wallpaper"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "NES Wallpaper.app"

  uninstall quit: "com.ubernes.wallpaper"

  zap trash: [
    "~/Library/Application Support/nes-wallpaper",
    "~/Library/Preferences/com.ubernes.wallpaper.plist",
    "~/Library/Screen Savers/NES Wallpaper.saver",
  ]
end
