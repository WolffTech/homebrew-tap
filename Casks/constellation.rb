cask "constellation" do
  version "0.11.0"
  sha256 "89c9baf92ad06363560de9ffb14364077785b144b0debc77c1ddd4e13a4c718e"

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
