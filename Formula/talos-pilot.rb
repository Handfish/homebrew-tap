class TalosPilot < Formula
  desc "A terminal UI for managing and monitoring Talos Linux Kubernetes clusters"
  homepage "https://github.com/Handfish/talos-pilot"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Handfish/talos-pilot/releases/download/v0.1.8/talos-pilot-aarch64-apple-darwin.tar.xz"
      sha256 "9801882f2066c2278797168ccb32bea73c7394ebcde4df80cb05ed677cad87bb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Handfish/talos-pilot/releases/download/v0.1.8/talos-pilot-x86_64-apple-darwin.tar.xz"
      sha256 "bde0f66f2ef016b77ad396dfa808bac7c5ea524752ce85579538b9d4945e39fa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Handfish/talos-pilot/releases/download/v0.1.8/talos-pilot-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5854aa534f44c71e7b85e136bbbe8381b9a62e22abfb525add75a86a0823ac0b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Handfish/talos-pilot/releases/download/v0.1.8/talos-pilot-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6828a0a7e5efe959d0d1f91b52a3a77c2746e8be579c6cdaf6e930f1402a5130"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "talos-pilot" if OS.mac? && Hardware::CPU.arm?
    bin.install "talos-pilot" if OS.mac? && Hardware::CPU.intel?
    bin.install "talos-pilot" if OS.linux? && Hardware::CPU.arm?
    bin.install "talos-pilot" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
