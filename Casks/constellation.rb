cask "constellation" do
  version "0.9.0"
  sha256 "74ee8b2b4bc7168d6b14383d744373a700fe2d4a5b4b353f0d34691b7c8559b1"

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
