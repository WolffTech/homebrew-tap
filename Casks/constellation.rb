cask "constellation" do
  version "0.5.0"
  sha256 "366565a5f503c6300bbc1ece8a98b73f9836a05a81b71f2d77d437b306dd9899"

  url "https://github.com/WolffTech/constellation/releases/download/v#{version}/Constellation-#{version}.dmg"
  name "Constellation"
  desc "Native workspace for local shell, SSH, RDP, and VNC sessions"
  homepage "https://github.com/WolffTech/constellation"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :sequoia

  app "Constellation.app"

  uninstall quit: "tech.wolff.Constellation"

  zap trash: [
    "~/Library/Application Support/Constellation",
    "~/Library/Preferences/tech.wolff.Constellation.plist",
  ]
end
