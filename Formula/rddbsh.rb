class Rddbsh < Formula
  desc "A SQL-like interactive CLI for Amazon DynamoDB (Rust port of awslabs/dynamodb-shell)"
  homepage "https://github.com/winebarrel/rddbsh"
  version "0.12.7"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/winebarrel/rddbsh/releases/download/v0.12.7/rddbsh-aarch64-apple-darwin.tar.xz"
    sha256 "7d74f7745d2f87952ff06eaa0f56d2509c63923a5c15b52fd4fd1e76ae65d8bf"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/winebarrel/rddbsh/releases/download/v0.12.7/rddbsh-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9d53bc2f672c522df03478ed6b3a9a9954b32114aed1e6e258b26491335947d5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/winebarrel/rddbsh/releases/download/v0.12.7/rddbsh-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "daa399172a37c4fd8660207aa4ca41eec1bb8f466e228676fbb1746233659123"
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
