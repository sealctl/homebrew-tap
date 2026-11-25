class Sealctl < Formula
  desc "API keys, SSH keys, encrypted volumes and backups, approved on your phone"
  homepage "https://sealctl.com"
  version "0.7.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/sealctl/sealctl/releases/download/v0.7.1/sealctl-0.7.1-aarch64-apple-darwin.tar.gz"
      sha256 "0c824a30540133132bc4096897489bba53e2e580883f73eaacec969efbb091d0"
    end
    on_intel do
      url "https://github.com/sealctl/sealctl/releases/download/v0.7.1/sealctl-0.7.1-x86_64-apple-darwin.tar.gz"
      sha256 "71b978844eb3c4ebda0da3867758a48100c36a935ebdcf6c042e638643d89460"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sealctl/sealctl/releases/download/v0.7.1/sealctl-0.7.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "330688bb64e69fa5bc53889529ed71bf59fc4354629da47e7fda25f8f9e99e92"
    end
    on_intel do
      url "https://github.com/sealctl/sealctl/releases/download/v0.7.1/sealctl-0.7.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "95a6955c80a9dc5970b21f8c36c2a7c925e35f9a02ebaebbbbc2d3f09c4c1053"
    end
  end

  depends_on "restic"

  def install
    bin.install "sealctl"
    # desktop notifications under the name "sealctl" with its icon (SPEC 5.2); sealctl finds
    # it in ../libexec
    libexec.install "sealctl Notifier.app" if OS.mac?
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
    assert_predicate libexec/"sealctl Notifier.app/Contents/MacOS/sealctl-notifier", :executable? if OS.mac?
  end
end
