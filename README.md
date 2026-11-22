# Homebrew tap for sealctl

```sh
brew install sealctl/tap/sealctl
```

[sealctl](https://github.com/sealctl/sealctl): secrets for AI coding agents, approved on your
phone. It keeps API keys out of `.env` files and away from agents, signs SSH logins and git
commits, and opens encrypted volumes and restic backups, all with keys derived from 24 words held
by the sealctl phone app. Get the app from [sealctl.com/docs#install](https://sealctl.com/docs#install),
then run `sealctl pair`.

`Formula/sealctl.rb` is updated automatically by sealctl's release workflow; don't edit it by hand.
