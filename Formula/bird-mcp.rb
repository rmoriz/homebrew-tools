class BirdMcp < Formula
  desc "MCP server for the BIRD Internet Routing Daemon"
  homepage "https://github.com/rmoriz/bird-mcp"
  url "https://github.com/rmoriz/bird-mcp/releases/download/latest/bird-mcp-aarch64-apple-darwin.tar.gz"
  version "0.1.0"
  sha256 "cdfd0a2cf41bf906c9a6616a7afb788e7532e51dfeca3c2622ca560e424beadb"
  license "MIT"

  livecheck do
    skip "upstream publishes only a rolling `latest` release"
  end

  on_macos do
    on_arm do
      url "https://github.com/rmoriz/bird-mcp/releases/download/latest/bird-mcp-aarch64-apple-darwin.tar.gz"
      sha256 "cdfd0a2cf41bf906c9a6616a7afb788e7532e51dfeca3c2622ca560e424beadb"
    end

    on_intel do
      url "https://github.com/rmoriz/bird-mcp/releases/download/latest/bird-mcp-x86_64-apple-darwin.tar.gz"
      sha256 "ff14d1f8265145412c9416a3f16e9e5d32bcf61d03e71956d20c35c596dd527d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmoriz/bird-mcp/releases/download/latest/bird-mcp-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "92c3f0fb816561ebaa340918553c823b5b580a9f0681f94da099f81571af83ac"
    end

    on_intel do
      url "https://github.com/rmoriz/bird-mcp/releases/download/latest/bird-mcp-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f18530cd8ba3380c328aed8a22b585902c36cc808c3cd7d013bf8a9fd6adafe3"
    end
  end

  def install
    bin.install "bird-mcp"
  end

  test do
    assert_match "bird-mcp #{version}", shell_output("#{bin}/bird-mcp --version")
  end
end
