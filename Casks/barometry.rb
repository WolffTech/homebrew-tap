cask "barometry" do
  version "1.1.0"
  sha256 "a03c1372f7989ac69c24354a10f396a2d5568b9079e089bfc7ed49f9d5574668"

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
