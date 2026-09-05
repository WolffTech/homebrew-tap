cask "constellation" do
  version "0.3.0"
  sha256 "11bde1b10ce4c46517a3221d9cb09808c277f5ce5c36ade7634bd210eb77388b"

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
