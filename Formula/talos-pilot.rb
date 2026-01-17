class TalosPilot < Formula
  desc "A terminal UI for managing and monitoring Talos Linux Kubernetes clusters"
  homepage "https://github.com/Handfish/talos-pilot"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Handfish/talos-pilot/releases/download/v0.1.7/talos-pilot-aarch64-apple-darwin.tar.xz"
      sha256 "be52730b90dca7c90285e11ce0f4e087ec2fc38784d31f5bd8a372117739aafb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Handfish/talos-pilot/releases/download/v0.1.7/talos-pilot-x86_64-apple-darwin.tar.xz"
      sha256 "af93b44e44844ede03fd354131c6d1d2e26931a00906b180bc04a2575358f2d6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Handfish/talos-pilot/releases/download/v0.1.7/talos-pilot-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e85b84311fd35f1ecbd1936793665a17b5f1f69732162084c6ce9f0f5d24940b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Handfish/talos-pilot/releases/download/v0.1.7/talos-pilot-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4a6628411d87d19aa1ff3a0d31203296c6bbfe59274b9bd2620eb9e7c8292508"
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
