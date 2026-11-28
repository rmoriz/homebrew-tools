class WhoisRmoriz < Formula
  desc "WHOIS and RDAP client, a behaviour-compatible port of Debian whois"
  homepage "https://github.com/rmoriz/whois"
  version "0.1.0"
  license "GPL-2.0-or-later"

  # Upstream publishes a rolling "latest" release: the tag and its assets move
  # with main while the version stays 0.1.0. Refresh the checksums from
  # https://github.com/rmoriz/whois/releases/download/latest/SHA256SUMS
  # whenever a download fails verification.
  livecheck do
    skip "Rolling release; the assets move with main and the version stays 0.1.0."
  end

  on_macos do
    on_arm do
      url "https://github.com/rmoriz/whois/releases/download/latest/whois-aarch64-apple-darwin.tar.gz"
      sha256 "6612c3b32bba2948663fa6189b3806a132625ba0b69f08c93eb4da255229c656"
    end

    on_intel do
      url "https://github.com/rmoriz/whois/releases/download/latest/whois-x86_64-apple-darwin.tar.gz"
      sha256 "43ba17771470db88eefed047622443055cdb61190a1f367db30b739431647d70"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rmoriz/whois/releases/download/latest/whois-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1e3337c19c74e5331f0f3975c8fa0365f4c7d8bdcf477500bb3ca92877d8d737"
    end

    on_intel do
      url "https://github.com/rmoriz/whois/releases/download/latest/whois-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6aa4ac966c5a3164daa9f374e172d18660169e7f26760bbaaeb2b71c4ef3f481"
    end
  end

  def install
    # Both commands need to be renamed: `whois` belongs to macOS (and to the
    # keg-only homebrew/core formula), `mkpasswd` to the `expect` formula.
    bin.install "whois" => "whois-rmoriz"
    bin.install "mkpasswd" => "mkpasswd-rmoriz"

    man1.install "man/whois.1" => "whois-rmoriz.1"
    man1.install "man/mkpasswd.1" => "mkpasswd-rmoriz.1"
    man5.install "man/whois.conf.5"

    # The completion scripts hard-code the Debian command names.
    inreplace "completions/whois.bash", "complete -F _whois whois", "complete -F _whois whois-rmoriz"
    inreplace "completions/mkpasswd.bash", "complete -F _mkpasswd mkpasswd",
              "complete -F _mkpasswd mkpasswd-rmoriz"
    bash_completion.install "completions/whois.bash" => "whois-rmoriz"
    bash_completion.install "completions/mkpasswd.bash" => "mkpasswd-rmoriz"

    # Upstream ships bash completions only, so the zsh ones live here. Drop them
    # in favour of upstream's files if they are ever added.
    (zsh_completion/"_whois-rmoriz").write <<~'ZSH'
      #compdef whois-rmoriz

      # zsh completion for whois-rmoriz, the Rust port of Debian whois. TYPE and
      # SOURCE lists are read from a server with `-q types|sources` and cached
      # for the shell, the way upstream's bash completion does it.

      typeset -gA _whois_rmoriz_lists

      _whois-rmoriz_fetch() {
        local cmd=$1 kind=$2 key="$1:$2" line
        local -a values
        (( ${+_whois_rmoriz_lists[$key]} )) && return 0
        while IFS= read -r line; do
          [[ -z $line || $line == '%'* ]] && continue
          values+=("${line%%:*}")
        done < <("$cmd" -q "$kind" 2>/dev/null)
        _whois_rmoriz_lists[$key]="${(F)values}"
        return 0
      }

      _whois-rmoriz_values() {
        _whois-rmoriz_fetch $words[1] $1
        local -a values
        values=(${(f)_whois_rmoriz_lists[$words[1]:$1]})
        (( $#values )) && compadd -a values
      }

      _whois-rmoriz_list() {
        _whois-rmoriz_fetch $words[1] $1
        local -a values
        values=(${(f)_whois_rmoriz_lists[$words[1]:$1]})
        (( $#values )) && _values -s , $1 $values
      }

      _whois-rmoriz_types() { _whois-rmoriz_values types }
      _whois-rmoriz_sources() { _whois-rmoriz_values sources }
      _whois-rmoriz_types_list() { _whois-rmoriz_list types }
      _whois-rmoriz_sources_list() { _whois-rmoriz_list sources }

      _arguments -s \
        '(-h --host --server)'{-h,--host=,--server=}'[connect to HOST]:host:_hosts' \
        '(-p --port)'{-p,--port=}'[connect to PORT]:port:_ports' \
        '-I[query whois.iana.org and follow its referral]' \
        '-H[hide legal disclaimers]' \
        '--verbose[explain what is being done]' \
        '--no-recursion[disable recursion from registry to registrar servers]' \
        '( --whois)--rdap[force an RDAP query]' \
        '( --rdap)--whois[force a WHOIS query]' \
        '--json[print the unmodified RDAP JSON response]' \
        '--emoji[encode emoji labels as punycode]' \
        '--help[display help and exit]' \
        '--version[output version information and exit]' \
        '-V[client tag sent to RIPE-like servers]:tag:' \
        '-a[also search all the mirrored databases]' \
        '-b[return brief IP address ranges with abuse contact]' \
        '-B[disable object filtering (show email addresses)]' \
        '-c[return the smallest IP range with an irt reference]' \
        '-d[return reverse DNS delegation objects too]' \
        '-G[disable grouping of associated objects]' \
        '-i[inverse lookup for ATTRibutes]:attribute:' \
        '-K[return primary keys only]' \
        '-l[find the one level less specific match]' \
        '-L[find all levels less specific matches]' \
        '-m[find all one level more specific matches]' \
        '-M[find all levels of more specific matches]' \
        '-r[disable recursive lookups for contact information]' \
        '-R[show the local copy even if it contains a referral]' \
        '-s[search the database mirrored from SOURCE]:source:_whois-rmoriz_sources_list' \
        '-g[find updates from SOURCE from serial FIRST to LAST]:update range:_whois-rmoriz_sources' \
        '-t[request template for object TYPE]:type:_whois-rmoriz_types' \
        '-T[only look for objects of TYPE]:type:_whois-rmoriz_types_list' \
        '-v[request verbose template for object TYPE]:type:_whois-rmoriz_types' \
        '-x[exact match]' \
        '-q[query server information]:information:(version sources types)' \
        '*:object:_hosts'
    ZSH

    (zsh_completion/"_mkpasswd-rmoriz").write <<~'ZSH'
      #compdef mkpasswd-rmoriz

      # zsh completion for mkpasswd-rmoriz, the Rust port of Debian mkpasswd.
      # Upstream ships a bash completion only. The method list comes from
      # `--method=help` and is cached for the shell.

      typeset -gA _mkpasswd_rmoriz_methods

      _mkpasswd-rmoriz_methods() {
        local cmd=$words[1] line name desc
        local -a methods
        if (( ! ${+_mkpasswd_rmoriz_methods[$cmd]} )); then
          while IFS= read -r line; do
            [[ -z $line || $line == Available* ]] && continue
            read -r name desc <<< $line
            methods+=("$name:$desc")
          done < <("$cmd" --method=help 2>/dev/null)
          _mkpasswd_rmoriz_methods[$cmd]="${(F)methods}"
        fi
        local -a entries
        entries=(${(f)_mkpasswd_rmoriz_methods[$cmd]})
        (( $#entries )) && _describe -t methods 'crypt method' entries
      }

      _arguments -s \
        '(-m --method -5)-5[like --method=md5crypt]' \
        '(-m --method -5)'{-m,--method=}'[select crypt method TYPE]:method:_mkpasswd-rmoriz_methods' \
        '(-H --hash)'{-H,--hash=}'[select crypt method TYPE]:method:_mkpasswd-rmoriz_methods' \
        '(-S --salt)'{-S,--salt=}'[use the specified SALT]:salt:' \
        '(-R --rounds)'{-R,--rounds=}'[use the specified NUMBER of rounds]:rounds:' \
        '(-P --password-fd)'{-P,--password-fd=}'[read the password from file descriptor NUM]:fd:' \
        '(-s --stdin)'{-s,--stdin}'[read the password from standard input]' \
        '(-h --help)'{-h,--help}'[display help and exit]' \
        '(-V --version)'{-V,--version}'[output version information and exit]' \
        '*:password:'
    ZSH
  end

  def caveats
    <<~EOS
      The commands are installed as `whois-rmoriz` and `mkpasswd-rmoriz` so they
      do not shadow /usr/bin/whois or the `mkpasswd` shipped with `expect`.

      These are upstream's prebuilt binaries, so they use upstream's build
      defaults: the client reads /etc/whois.conf and mkpasswd has no libxcrypt
      methods (yescrypt, scrypt, sm3, nt).
    EOS
  end

  test do
    assert_match "whois/rmoriz #{version}", shell_output("#{bin}/whois-rmoriz --version")
    assert_match "mkpasswd/rmoriz #{version}", shell_output("#{bin}/mkpasswd-rmoriz --version")

    assert_path_exists man1/"whois-rmoriz.1"
    assert_path_exists man1/"mkpasswd-rmoriz.1"
    assert_path_exists man5/"whois.conf.5"
    assert_path_exists zsh_completion/"_whois-rmoriz"
    assert_path_exists zsh_completion/"_mkpasswd-rmoriz"

    # A fixed salt makes the output deterministic and proves that crypt(3) works
    # in the prebuilt binary.
    assert_equal "$6$saltsalt$qFmFH.bQmmtXzyBY0s9v7Oicd2z4XSIecDzlB5KiA2/jctKu9YterLp8wwnSq.qc.eoxqOmSuNp2xS0ktL3nh/",
                 shell_output("#{bin}/mkpasswd-rmoriz -m sha-512 -S saltsalt password").strip
  end
end
