cask "barometry" do
  version "1.0.0"
  sha256 "85323f9eef0562e19cd0c7f4377a9996c285753970e89b69a4b7c98714fa3bc3"

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
