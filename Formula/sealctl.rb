class Sealctl < Formula
  desc "Hardware-wallet backed encryption: volumes, backups, secrets, SSH (Ledger OpenPGP)"
  homepage "https://github.com/oleksiyp/sealctl"
  version "0.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/oleksiyp/sealctl/releases/download/v0.1.0/sealctl-0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "c9c77292177e3f579541e3b27edac48b29d6187f8accf38f23e691cad7a7ef13"
    end
    on_intel do
      url "https://github.com/oleksiyp/sealctl/releases/download/v0.1.0/sealctl-0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "9f4969911e6df1fcd9ca123a8a4e45dc69fee408ab908103772f82579802c068"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/oleksiyp/sealctl/releases/download/v0.1.0/sealctl-0.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fb0d38c316d1da943fbafadd3ba4933efa919a644bc1f5de3087da69dd0862b7"
    end
    on_intel do
      url "https://github.com/oleksiyp/sealctl/releases/download/v0.1.0/sealctl-0.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "86d2d11aa49c7b0d2732b38a07e0b696cc61e972d0a9c2b40b799ff59a92e6d3"
    end
  end

  depends_on "restic"

  def install
    bin.install "sealctl"
    bash_completion.install "completions/sealctl.bash" => "sealctl"
    zsh_completion.install "completions/_sealctl"
    fish_completion.install "completions/sealctl.fish"
  end

  def caveats
    <<~EOS
      sealctl needs the OpenPGP app on your Ledger (Ledger Live → developer mode).
      For Bluetooth, see https://github.com/oleksiyp/sealctl/blob/main/docs/bluetooth-app.md
      Get started: sealctl setup --uid "Your Name <you@example.org>"
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sealctl --version")
    assert_match "volume", shell_output("#{bin}/sealctl --help")
  end
end
