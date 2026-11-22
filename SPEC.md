# homebrew-tap spec

This repository is the Homebrew tap `sealctl/tap`. It holds `Formula/sealctl.rb`, which installs the prebuilt `sealctl` binary from the GitHub release.

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
| Description | "API keys, SSH keys, encrypted volumes and backups, approved on your phone" (under 80 characters, no leading article, no product name) |
| Homepage | `https://sealctl.com` |
| Depends on | `restic` (backups) |
| License | `MIT` |
| Caveats | Get the sealctl app on your phone (`https://sealctl.com/docs#install`), then run `sealctl pair`; `sealctl ai install` for AI coding agents |
| Test | `sealctl --version` contains the version; `sealctl --help` lists `pair`. Planned: `sealctl status --json` exits 3 (not paired) |

No bottles: the tarballs are already binaries. No build from source in the tap; `cargo install` is documented on the website for that.

The formula text comes from `scripts/render-formula.sh` in `sealctl/sealctl`, so changes to it go there, not here.

Optional: a `livecheck` block (`strategy :github_latest`) so `brew livecheck` reports new versions.

## How releases update it

Automated by `.github/workflows/packages.yml` in `sealctl/sealctl`. Nobody edits `Formula/sealctl.rb` by hand.

1. A maintainer pushes tag `vX.Y.Z` on `sealctl/sealctl` (the tag must match the workspace version in `Cargo.toml`).
2. The workflow builds macOS and Linux tarballs and their `.sha256` files (tag builds start without the Actions cache), install-tests them (including `brew install` and `brew test` of a formula rendered from the local tarballs), writes `SHA256SUMS`, attests every file with `actions/attest-build-provenance`, and publishes the GitHub release.
3. Job `tap` downloads the published tarballs, checks each against the `.sha256` computed at build time and runs `gh attestation verify` on it. Only then does it check out this repository with the deploy key from secret `HOMEBREW_TAP_DEPLOY_KEY`, run `scripts/render-formula.sh <version> <release URL> dist > Formula/sealctl.rb` and commit `sealctl X.Y.Z` as `github-actions[bot]`.
4. `main` here is protected by the ruleset `main` (pull requests only, squash merge). The job pushes to `main`; when the ruleset refuses that push, it pushes branch `formula/sealctl-X.Y.Z` instead and links a pull request in the run summary, which a maintainer opens and merges. Adding the deploy key as a bypass actor of the ruleset makes step 4 a direct push again.

The deploy key is the only write access the workflow has here. It is a repository deploy key on `sealctl/homebrew-tap` with write access; its private half is the secret in `sealctl/sealctl`. The formula pins each tarball by `sha256`, so a changed release asset fails `brew install` rather than installing.

## README

Short: the install command, what sealctl is (the website's summary), where to get the phone app (`https://sealctl.com/docs#install`) and `sealctl pair`, and "`Formula/sealctl.rb` is updated by sealctl's release workflow; don't edit it by hand."

## Testing

Add `.github/workflows/check.yml`, run on every push to `main` (pushes made with the deploy key trigger workflows) and on pull requests:

| Job | Runner | Steps |
| --- | --- | --- |
| audit | `macos-latest` | `brew tap sealctl/tap "$GITHUB_WORKSPACE"`; `brew audit --strict --online --tap sealctl/tap`; `brew style sealctl/tap` |
| install | `macos-latest`, `ubuntu-24.04` (Homebrew on Linux) | `brew install sealctl/tap/sealctl`; `brew test sealctl/tap/sealctl`; `sealctl --version` |

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
