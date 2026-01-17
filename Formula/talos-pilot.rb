class TalosPilot < Formula
  desc "A terminal UI for managing and monitoring Talos Linux Kubernetes clusters"
  homepage "https://github.com/Handfish/talos-pilot"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Handfish/talos-pilot/releases/download/v0.1.5/talos-pilot-aarch64-apple-darwin.tar.xz"
      sha256 "e26c631eb322709faab2ad16258eb85e691a1d577b5a693ddd937d6580045ac6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Handfish/talos-pilot/releases/download/v0.1.5/talos-pilot-x86_64-apple-darwin.tar.xz"
      sha256 "23addc625b718c68b210a8edaf8aa3421df12a3eb70b7124e5bfa486c7cd5ed4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Handfish/talos-pilot/releases/download/v0.1.5/talos-pilot-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1070c2940c9628e937eaca8e508818c050abc3843e8e22e7d04650280de3734f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Handfish/talos-pilot/releases/download/v0.1.5/talos-pilot-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fdcf5ab8b9994b1d786b1995759f620c8738f36ebf50ec698a79d8c8f5344aa3"
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
