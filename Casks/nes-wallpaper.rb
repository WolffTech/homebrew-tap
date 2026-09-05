cask "nes-wallpaper" do
  version "1.2.0"
  sha256 "8a3b564bd83fa73da8717d86a72d4d402434d5e8173bd93f6843c1f79329f6d4"

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
