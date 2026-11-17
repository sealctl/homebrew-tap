class Sealctl < Formula
  desc "Hardware-wallet backed encryption: volumes, backups, secrets, SSH (Ledger OpenPGP)"
  homepage "https://github.com/oleksiyp/sealctl"
  version "0.2.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/oleksiyp/sealctl/releases/download/v0.2.0/sealctl-0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "fb3093252a6051eb37b5a37d91fb01e4c1aaf83d385499d4745bca471f0eb673"
    end
    on_intel do
      url "https://github.com/oleksiyp/sealctl/releases/download/v0.2.0/sealctl-0.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "ddbb4de2677607c3e16138918a9d8b9a3a8e8dabebecb10be68e7dd9d15bce82"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/oleksiyp/sealctl/releases/download/v0.2.0/sealctl-0.2.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "495a00f1d86dea96c94f8e75fa7f949da38b570f0ef4d5eb2db76e2681b1d052"
    end
    on_intel do
      url "https://github.com/oleksiyp/sealctl/releases/download/v0.2.0/sealctl-0.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5ebf835250fd6de87d38f90b7285c1e3072bbfc4d5bbdba205ae82a036bc0a19"
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
