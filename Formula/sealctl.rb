class Sealctl < Formula
  desc "Hardware-wallet backed encryption: volumes, backups, secrets, SSH (Ledger OpenPGP)"
  homepage "https://github.com/oleksiyp/sealctl"
  version "0.4.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/oleksiyp/sealctl/releases/download/v0.4.0/sealctl-0.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "67228bcdc4d53c2e6169ab74ea1446f738ee60a9603acded48c7c1cbf96babba"
    end
    on_intel do
      url "https://github.com/oleksiyp/sealctl/releases/download/v0.4.0/sealctl-0.4.0-x86_64-apple-darwin.tar.gz"
      sha256 "95022b0d97445c304132cf1f1f6f0290909ffaabeeded73de661014e92e1c57e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/oleksiyp/sealctl/releases/download/v0.4.0/sealctl-0.4.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5fac7c931f99481b0f8276143f94c45585538865b000c72e5dc3de260b04fc3b"
    end
    on_intel do
      url "https://github.com/oleksiyp/sealctl/releases/download/v0.4.0/sealctl-0.4.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4643eb854f9827ae0ece926539c99b2711a96e66bf3e786c917223d5bf7158da"
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
