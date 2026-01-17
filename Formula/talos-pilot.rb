class TalosPilot < Formula
  desc "A terminal UI for managing and monitoring Talos Linux Kubernetes clusters"
  homepage "https://github.com/Handfish/talos-pilot"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Handfish/talos-pilot/releases/download/v0.1.4/talos-pilot-aarch64-apple-darwin.tar.xz"
      sha256 "1594e9805053aa9ce2031a47fbe4245335e1d84b77834ff537304f5edb644aaf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Handfish/talos-pilot/releases/download/v0.1.4/talos-pilot-x86_64-apple-darwin.tar.xz"
      sha256 "021789549196513436f3468351edd5f0748edf1510143da425d3a9ce41d05baf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Handfish/talos-pilot/releases/download/v0.1.4/talos-pilot-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8655c242a3974c08f3828c9570660703cd9e68d77b325876a1933ae833d006f4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Handfish/talos-pilot/releases/download/v0.1.4/talos-pilot-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b8bebcd1925abdf4c8c0c11281c0e44702256ee66f6877ae780e8df3a9976b16"
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
