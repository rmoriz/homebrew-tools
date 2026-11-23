# AGENTS.md

Instructions for agents working in `rmoriz/homebrew-tools`, a personal Homebrew tap.

## Layout

- `Formula/*.rb` — one formula per tool. Nothing else belongs in `Formula/`.
- `README.md` — human index of the tap. Every formula must be listed with its
  current version and description; both must match the formula file.
- `.github/workflows/tests.yml` — `brew test-bot` plus the `style` job that runs
  `brew style`. Workflows pin third-party actions by commit SHA.

## Ground rules

- Do not add `Co-Authored-By: Claude` or similar trailers to commits.
- Do not remove or rewrite a formula you were not asked to touch.
- A local checkout of the tap usually lives at
  `/opt/homebrew/Library/Taps/rmoriz/homebrew-tools`. It can carry
  uncommitted changes that exist nowhere else; diff it against this repo
  before overwriting anything.
- Commit messages name the formula and state *why* the change is needed,
  e.g. `pdns: install pdnsutil completions; add git-time`.
- Push after committing. Link any release notes instead of pasting them.

## Updating a version

1. Find the real upstream release: `brew livecheck <tap>/<formula>`, the
   upstream release page, or its download directory. Never guess a version.
2. Prefer a release tarball. If upstream only ships binaries, keep the
   per-platform `url` + `sha256` blocks and let Homebrew derive `version`
   from the URL (no explicit `version` line, `using: :nounzip` on each URL).
3. Download the artifact and verify the checksum before writing it:
   `shasum -a 256 <file>`.
4. Update the formula, then the README table.
5. Build it: `brew reinstall --build-from-source <tap>/<formula>` and
   `brew test <tap>/<formula>`.

## Checks before committing

```console
brew style Formula/
brew audit --strict <tap>/<formula>
brew livecheck <tap>/<formula>
```

All three must be clean. `brew audit` and `brew livecheck` need the tap to be
trusted on the machine; `brew trust <tap>` once if they refuse to load it.

## Formula conventions

- `desc` is a sentence fragment, no leading article, at most 80 characters.
- Keep `license` in SPDX form (`GPL-2.0-only`, not `GPL-2.0`).
- Shell completions ship separately upstream are fetched in `install` and
  placed via `bash_completion.install` and `zsh_completion.install`, installed
  under the command name (`"file.bash" => "cmd"`).
- Add a `livecheck` block when the download page is not auto-detectable, and a
  comment explaining the URL choice.
- Prefer the narrowest `test do` that proves the binary runs.
