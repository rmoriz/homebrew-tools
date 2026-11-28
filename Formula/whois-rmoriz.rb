class WhoisRmoriz < Formula
  desc "WHOIS and RDAP client, a behaviour-compatible port of Debian whois"
  homepage "https://github.com/rmoriz/whois"
  url "https://github.com/rmoriz/whois/archive/2248acfaa1c454701550f9a05c5cd3d3565817a2.tar.gz"
  version "0.1.0"
  sha256 "92062181f564fb0e71a185169698fe400368a63cbe7d5db9151c62fcd71cfecd"
  license "GPL-2.0-or-later"
  head "https://github.com/rmoriz/whois.git", branch: "main"

  # No tagged release yet, so the version comes from Cargo.toml and the source
  # is pinned to a commit on main.
  livecheck do
    skip "No tagged releases yet; the formula pins a commit on main."
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libidn2"
  depends_on "libxcrypt"

  def install
    # build.rs bakes this path into the binary, so point it at the prefix
    # instead of the upstream default /etc/whois.conf.
    ENV["CONFIG_FILE"] = (etc/"whois.conf").to_s

    # Install into a staging directory: both commands need to be renamed, since
    # `whois` belongs to macOS (and to the keg-only homebrew/core formula) and
    # `mkpasswd` to the `expect` formula.
    system "cargo", "install", *std_cargo_args(root: buildpath/"stage")
    bin.install "stage/bin/whois" => "whois-rmoriz"
    bin.install "stage/bin/mkpasswd" => "mkpasswd-rmoriz"

    man1.install "man/whois.1" => "whois-rmoriz.1"
    man1.install "man/mkpasswd.1" => "mkpasswd-rmoriz.1"
    man5.install "man/whois.conf.5"

    # The completion scripts hard-code the Debian command names.
    inreplace "completions/whois.bash", "complete -F _whois whois", "complete -F _whois whois-rmoriz"
    inreplace "completions/mkpasswd.bash", "complete -F _mkpasswd mkpasswd",
              "complete -F _mkpasswd mkpasswd-rmoriz"
    bash_completion.install "completions/whois.bash" => "whois-rmoriz"
    bash_completion.install "completions/mkpasswd.bash" => "mkpasswd-rmoriz"
  end

  def caveats
    <<~EOS
      The commands are installed as `whois-rmoriz` and `mkpasswd-rmoriz` so they
      do not shadow /usr/bin/whois or the `mkpasswd` shipped with `expect`.

      The client reads its configuration from:
        #{etc}/whois.conf
    EOS
  end

  test do
    assert_match "whois/rmoriz #{version}", shell_output("#{bin}/whois-rmoriz --version")
    assert_match "mkpasswd/rmoriz #{version}", shell_output("#{bin}/mkpasswd-rmoriz --version")

    assert_path_exists man1/"whois-rmoriz.1"
    assert_path_exists man1/"mkpasswd-rmoriz.1"
    assert_path_exists man5/"whois.conf.5"

    # A fixed salt makes the output deterministic and proves that the
    # libxcrypt methods were compiled in instead of the pure-Rust fallbacks.
    assert_equal "$6$saltsalt$qFmFH.bQmmtXzyBY0s9v7Oicd2z4XSIecDzlB5KiA2/jctKu9YterLp8wwnSq.qc.eoxqOmSuNp2xS0ktL3nh/",
                 shell_output("#{bin}/mkpasswd-rmoriz -m sha-512 -S saltsalt password").strip
  end
end
