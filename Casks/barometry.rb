cask "barometry" do
  version "1.3.0"
  sha256 "49272a265e3f4da75d610cce89c29df9ca39193c16807e7d46a9bbd3ab50760d"

  url "https://github.com/WolffTech/barometry/releases/download/v#{version}/Barometry-#{version}.dmg"
  name "Barometry"
  desc "Live system stats in the menu bar with a detailed dashboard"
  homepage "https://github.com/WolffTech/barometry"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :tahoe

  app "Barometry.app"

  uninstall quit: "tech.wolff.barometry"

  zap trash: "~/Library/Preferences/tech.wolff.barometry.plist"
end
