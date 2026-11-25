class GitTime < Formula
  desc "Verifiable RFC 3161 timestamps inside git commits"
  homepage "https://github.com/rmoriz/git-time"
  url "https://github.com/rmoriz/git-time/releases/download/v0.3.1/git-time-aarch64-apple-darwin", using: :nounzip
  sha256 "43511f6a488f4e46a626be135dba2b40692adda2ba069a1e57d3dca49aabc9e6"
  license "GPL-2.0-only"

  on_macos do
    on_arm do
      url "https://github.com/rmoriz/git-time/releases/download/v0.3.1/git-time-aarch64-apple-darwin", using: :nounzip
      sha256 "43511f6a488f4e46a626be135dba2b40692adda2ba069a1e57d3dca49aabc9e6"
    end

    on_intel do
      url "https://github.com/rmoriz/git-time/releases/download/v0.3.1/git-time-x86_64-apple-darwin", using: :nounzip
      sha256 "d8fd478468dc7bf2020c52dd81657f15ab70a466ed46f290dbd8ad9f0d6e6537"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmoriz/git-time/releases/download/v0.3.1/git-time-aarch64-unknown-linux-musl", using: :nounzip
      sha256 "d4c3181d9d9601cb5fb909452d15e7ddbba74e48c7ce490d40eea564332f7fe9"
    end

    on_intel do
      url "https://github.com/rmoriz/git-time/releases/download/v0.3.1/git-time-x86_64-unknown-linux-musl", using: :nounzip
      sha256 "63cff6423a26b6a4eb6f4ac63b788b9d4d43c2697507930bc6f03240bafc8a2d"
    end
  end

  resource "manpage" do
    url "https://raw.githubusercontent.com/rmoriz/git-time/v0.3.1/docs/git-time.1"
    sha256 "c6db70eacbfde134376bbe33746b9311fd1880fcf80a82e850e48d4a77a0819d"
  end

  def install
    bin.install Dir["git-time-*"].first => "git-time"

    resource("manpage").stage do
      man1.install "git-time.1"
    end
  end

  test do
    assert_match "git time #{version}", shell_output("#{bin}/git-time --version")
    assert_path_exists man1/"git-time.1"
  end
end
