class Rddbsh < Formula
  desc "A SQL-like interactive CLI for Amazon DynamoDB (Rust port of awslabs/dynamodb-shell)"
  homepage "https://github.com/winebarrel/rddbsh"
  version "0.12.1+3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/winebarrel/rddbsh/releases/download/v0.12.1+3/rddbsh-aarch64-apple-darwin.tar.xz"
    sha256 "77b0d4111d9cc07cce9b4fd6482cf9430039d3a9f16bff83007d7e859fd9e7d0"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/winebarrel/rddbsh/releases/download/v0.12.1+3/rddbsh-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e670c30182fc1fe6d6f42aa4d4c458634392e96a3edae59545f712cae7d3575f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/winebarrel/rddbsh/releases/download/v0.12.1+3/rddbsh-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "79b94a65d2411613f7e34f7709052b7a4cfdb8375e0e1d23c664d7060bf7e72f"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "rddbsh"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "rddbsh"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "rddbsh"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
