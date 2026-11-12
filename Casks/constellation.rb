cask "constellation" do
  version "0.12.0"
  sha256 "99b7a743986eba403470150f7118c4ff1895a5963dfa9aea3b77f706cb03d7d3"

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
