class Sealctl < Formula
  desc "Hardware-wallet backed encryption: volumes, backups, secrets, SSH (Ledger OpenPGP)"
  homepage "https://github.com/oleksiyp/sealctl"
  version "0.3.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/oleksiyp/sealctl/releases/download/v0.3.0/sealctl-0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "f28156dfaa98914c74516ecb4348260410a1a76196c60b77d79c600f0fda7f20"
    end
    on_intel do
      url "https://github.com/oleksiyp/sealctl/releases/download/v0.3.0/sealctl-0.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "701ccb8d32fe128005e392f8f6f139c1136b63df43c5f1ea1f5cab28fef50e5f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/oleksiyp/sealctl/releases/download/v0.3.0/sealctl-0.3.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "099d188353eeca9fc4afceb9a7723bbe8f0248575c20242eb51180be509a87c3"
    end
    on_intel do
      url "https://github.com/oleksiyp/sealctl/releases/download/v0.3.0/sealctl-0.3.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "44de65b5c7fdabfd8657df09ef83a5f1695b2da41b7b2333ec3c6d4c4d9b8cf7"
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
