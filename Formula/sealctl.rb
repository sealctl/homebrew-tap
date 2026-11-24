class Sealctl < Formula
  desc "API keys, SSH keys, encrypted volumes and backups, approved on your phone"
  homepage "https://sealctl.com"
  version "0.7.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/sealctl/sealctl/releases/download/v0.7.0/sealctl-0.7.0-aarch64-apple-darwin.tar.gz"
      sha256 "b251c440727ca9008678d005a21e5ccf9551d602409568d376217f6845bda334"
    end
    on_intel do
      url "https://github.com/sealctl/sealctl/releases/download/v0.7.0/sealctl-0.7.0-x86_64-apple-darwin.tar.gz"
      sha256 "5cd0dcababc93e4d5c27bca55181a4cfa0a58501cbbb05707ca016c375ed3fbb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sealctl/sealctl/releases/download/v0.7.0/sealctl-0.7.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1d57380727b0e546b2d0e20b4e8da94779ffb2848efcfbdcc648aeabf07c876f"
    end
    on_intel do
      url "https://github.com/sealctl/sealctl/releases/download/v0.7.0/sealctl-0.7.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "dd7e06c943cf722fceedf626d7636b411f7e9be04b425afd770e06e8ce3510ff"
    end
  end

  depends_on "restic"

  def install
    bin.install "sealctl"
    doc.install "THIRD-PARTY-NOTICES.md"
    bash_completion.install "completions/sealctl.bash" => "sealctl"
    zsh_completion.install "completions/_sealctl"
    fish_completion.install "completions/sealctl.fish"
  end

  def caveats
    <<~EOS
      Get the sealctl app on your phone (https://sealctl.com/docs#install), then run:
        sealctl pair
      For AI coding agents: sealctl ai install
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sealctl --version")
    assert_match "pair", shell_output("#{bin}/sealctl --help")
  end
end
