class Sealctl < Formula
  desc "Hardware-wallet backed encryption: volumes, backups, secrets, SSH (Ledger OpenPGP)"
  homepage "https://github.com/oleksiyp/sealctl"
  version "0.5.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/oleksiyp/sealctl/releases/download/v0.5.0/sealctl-0.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "321c7caa398273a5c9af4ead3cf998c826363c992259e4877d0ed6e4d4b6c8ce"
    end
    on_intel do
      url "https://github.com/oleksiyp/sealctl/releases/download/v0.5.0/sealctl-0.5.0-x86_64-apple-darwin.tar.gz"
      sha256 "d1896ab1d8fd78d412449949817d3fe9adb3207b902db1a62fb70b0038bf360e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/oleksiyp/sealctl/releases/download/v0.5.0/sealctl-0.5.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c56fad9b393f18023d8ab94dac5783eacd94c9c1c3ef659780a0b6b78308ac53"
    end
    on_intel do
      url "https://github.com/oleksiyp/sealctl/releases/download/v0.5.0/sealctl-0.5.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b5d61c0f8ce8b70ce060efb1c2401e96c09a18c39275daa21ccdaff48bdc0783"
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
