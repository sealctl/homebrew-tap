# homebrew-tap spec

This repository is the Homebrew tap `sealctl/tap`. It holds `Formula/sealctl.rb`, which installs the prebuilt `sealctl` binary from the GitHub release, and, from the phone release on, `Formula/sealctl@0.6.rb` for people still leaving the Ledger version.

```sh
brew install sealctl/tap/sealctl
```

## Formula

| Field | Value |
| --- | --- |
| Class | `Sealctl` |
| Source | Prebuilt tarballs from `https://github.com/sealctl/sealctl/releases/download/v<version>/` |
| Platforms | macOS arm64 and x86_64; Linux arm64 and x86_64 (glibc 2.34 or later) |
| Tarball name | `sealctl-<version>-<target>.tar.gz`, with a `.sha256` file next to it |
| Installs | `bin/sealctl`; bash, zsh and fish completions from `completions/` in the tarball |
| Depends on | `restic` (backups), `:recommended` from the phone release on |
| License | `MIT` |
| Test | `sealctl --version` contains the version; `sealctl --help` lists a known subcommand; from the phone release on also `sealctl status --json` exits 3 (not paired), as `render-formula.sh` writes it |

No bottles: the tarballs are already binaries. No build from source in the tap; `cargo install` is documented on the website for that.

### Changes due with 0.6.0 and the phone release (0.7.0)

The formula text comes from `scripts/render-formula.sh` in `sealctl/sealctl`, so these edits go there, not here:

| Field | Now (0.5.0) | 0.6.0 (Ledger, adds `unseal`) | Phone release (0.7.0) |
| --- | --- | --- | --- |
| `desc` | "Hardware-wallet backed encryption: volumes, backups, secrets, SSH (Ledger OpenPGP)" | Unchanged | "Secrets for AI coding agents, approved on your phone" (under 80 characters, no article, no product name) |
| `homepage` | `https://github.com/sealctl/sealctl` | Unchanged | `https://sealctl.com` |
| `caveats` | Ledger and Bluetooth setup | Adds: "To leave the Ledger: sealctl unseal --all. It hands everything back under passwords of your own." | "Get the sealctl app on your phone, then run: sealctl pair". And: "Coming from 0.5 with a Ledger? Hand everything back first: brew install sealctl/tap/sealctl@0.6, then run its sealctl unseal --all. See https://sealctl.com/docs/from-ledger" |
| `test` | `--help` contains `volume` | `--help` contains `unseal` | `--help` contains `pair` |

Optional: a `livecheck` block (`strategy :github_latest`) so `brew livecheck` reports new versions.

## How releases update it

Fully automated by `.github/workflows/packages.yml` in `sealctl/sealctl`. Nobody edits `Formula/sealctl.rb` by hand.

1. A maintainer pushes tag `vX.Y.Z` on `sealctl/sealctl` (the tag must match the workspace version in `Cargo.toml`).
2. The workflow builds macOS and Linux tarballs and their `.sha256` files, install-tests them (including `brew install` and `brew test` of a formula rendered from the local tarballs), and publishes the GitHub release.
3. Job `tap` checks out this repository with the deploy key from secret `HOMEBREW_TAP_DEPLOY_KEY`, runs `scripts/render-formula.sh <version> <release URL> dist > Formula/sealctl.rb`, and pushes a commit titled `sealctl X.Y.Z` as `github-actions[bot]`.

The deploy key is the only write access the workflow has here. It is a repository deploy key on `sealctl/homebrew-tap` with write access; its private half is the secret in `sealctl/sealctl`.

## Naming after the move to the org

- The repositories moved from `oleksiyp/*` to `sealctl/*`. The tap name is now `sealctl/tap`.
- GitHub redirects the old URLs, so `oleksiyp/tap` keeps updating for existing users, but under the old name. The README tells them to switch:

  ```sh
  brew untap oleksiyp/tap
  brew install sealctl/tap/sealctl
  ```

- Never create new repositories named `oleksiyp/homebrew-tap` or `oleksiyp/sealctl`: that breaks the redirects.
- No `tap_migrations.json`: the old and new tap names point to the same repository, so a migration entry would point at itself.
- No `sealctl@0.5`. One versioned formula, `sealctl@0.6`, is added when 0.7.0 ships: 0.7 has no Ledger reader, and `brew upgrade` would otherwise leave a 0.5.0 user with no way to run `unseal`. It is `keg_only :versioned_formula` (it does not link `bin/sealctl`, so it never clashes with `sealctl`), pinned to the last 0.6.x tarballs, and run as `$(brew --prefix sealctl@0.6)/bin/sealctl unseal --all`. Its caveats say exactly that. `render-formula.sh` renders it once from the 0.6.x release; it is not updated by later releases.

## README

Short: the install command, one line on what sealctl is (same as `desc`), the switch-over note above, a line for Ledger users ("Leaving the Ledger version: `sealctl unseal --all` with 0.6; `sealctl@0.6` stays installable"), and "`Formula/sealctl.rb` is updated by sealctl's release workflow; don't edit it by hand." The current README still describes the Ledger product and changes with the phone release.

## Testing

Add `.github/workflows/check.yml`, run on every push to `main` (pushes made with the deploy key trigger workflows) and on pull requests:

| Job | Runner | Steps |
| --- | --- | --- |
| audit | `macos-latest` | `brew tap sealctl/tap "$GITHUB_WORKSPACE"`; `brew audit --strict --online --tap sealctl/tap`; `brew style sealctl/tap` |
| install | `macos-latest`, `ubuntu-24.04` (Homebrew on Linux) | `brew install sealctl/tap/sealctl`; `brew test sealctl/tap/sealctl`; `sealctl --version`; once it exists, `brew install sealctl/tap/sealctl@0.6` next to it and its `sealctl --help` lists `unseal` |

- Fix what `brew audit --strict` reports in `render-formula.sh` (for example, a `version` line it calls redundant because the URLs carry the version), not in this repo.
- A failed check after a release means the release is broken for Homebrew users: fix forward with a patch release.

Locally, before changing `render-formula.sh`:

```sh
brew tap sealctl/tap ~/dev/encrypted-disk/homebrew-tap
brew audit --strict --online sealctl/tap/sealctl
brew reinstall sealctl/tap/sealctl && brew test sealctl/tap/sealctl
```

## Later: a cask

Only if a GUI appears (for example a macOS menu-bar app):

- `Casks/sealctl-app.rb` installing a signed and notarized `.dmg` or `.zip` from the GitHub release, with `depends_on formula: "sealctl"` if it drives the CLI.
- Signing needs a Developer ID Application certificate from the Apple Developer account, and notarization in the release workflow.
- The release workflow renders the cask the same way it renders the formula (`scripts/render-cask.sh`), pushed with the same deploy key.
- `brew audit --cask --strict --online` and an install test join `check.yml`.

Not planned now.
