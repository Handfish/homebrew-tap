class TalosPilot < Formula
  desc "A terminal UI for managing and monitoring Talos Linux Kubernetes clusters"
  homepage "https://github.com/Handfish/talos-pilot"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Handfish/talos-pilot/releases/download/v0.1.6/talos-pilot-aarch64-apple-darwin.tar.xz"
      sha256 "f69a87f7e216d1e2620e2797d1605d236a5a627da2ff0e857e3be0f50ee3a9d2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Handfish/talos-pilot/releases/download/v0.1.6/talos-pilot-x86_64-apple-darwin.tar.xz"
      sha256 "a280ea1741afd9993a0483a3517b6be34874a5c85b46b844507ffe55ced9a7bb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Handfish/talos-pilot/releases/download/v0.1.6/talos-pilot-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d61a7087583c1b27b4e2de73f84ece81f0904c382263a1478b8ad16ebb569a46"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Handfish/talos-pilot/releases/download/v0.1.6/talos-pilot-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8b738704210685e2882ff449cb49258959a046c83192fb1e28c5f043fad5e489"
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
