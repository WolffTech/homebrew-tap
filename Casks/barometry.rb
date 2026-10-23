cask "barometry" do
  version "1.2.0"
  sha256 "b1ceba6daf5a2202e1549354d6c5d2c07633660b8744c3da41b4070761beaace"

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
