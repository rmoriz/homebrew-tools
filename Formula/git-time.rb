class GitTime < Formula
  desc "Verifiable RFC 3161 timestamps inside git commits"
  homepage "https://github.com/rmoriz/git-time"
  url "https://github.com/rmoriz/git-time/releases/download/v0.3.0/git-time-aarch64-apple-darwin", using: :nounzip
  sha256 "924394ce7b0c3d583ba174538a92f21ed3fd4321674915892d3daa08f0675f48"
  license "GPL-2.0-only"

  on_macos do
    on_arm do
      url "https://github.com/rmoriz/git-time/releases/download/v0.3.0/git-time-aarch64-apple-darwin", using: :nounzip
      sha256 "924394ce7b0c3d583ba174538a92f21ed3fd4321674915892d3daa08f0675f48"
    end

    on_intel do
      url "https://github.com/rmoriz/git-time/releases/download/v0.3.0/git-time-x86_64-apple-darwin", using: :nounzip
      sha256 "fee2d17bf4075a7178f652335e1480db39b559fadca2cd921ef800c9e353e91a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmoriz/git-time/releases/download/v0.3.0/git-time-aarch64-unknown-linux-musl", using: :nounzip
      sha256 "5518786bd6a72ef0111458ac2f57514dc44771746ca15fdcddc2f9f5c1201980"
    end

    on_intel do
      url "https://github.com/rmoriz/git-time/releases/download/v0.3.0/git-time-x86_64-unknown-linux-musl", using: :nounzip
      sha256 "5cd6c9438916654218a756f71119a5c11938f7621f91f248256e1f05d190117c"
    end
  end

  resource "manpage" do
    url "https://raw.githubusercontent.com/rmoriz/git-time/v0.3.0/docs/git-time.1"
    sha256 "e1025926ac6ec7540470375c0dafb8ed10f1ac110dcb6786ebbfa130260c1d20"
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
