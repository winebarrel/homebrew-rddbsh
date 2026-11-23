class Rddbsh < Formula
  desc "A SQL-like interactive CLI for Amazon DynamoDB (Rust port of awslabs/dynamodb-shell)"
  homepage "https://github.com/winebarrel/rddbsh"
  version "0.12.1+4"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/winebarrel/rddbsh/releases/download/v0.12.1+4/rddbsh-aarch64-apple-darwin.tar.xz"
    sha256 "12a0e72261ad6540798f1f00baa276008b5bcef0ab5a89516cc2fe037f9ed543"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/winebarrel/rddbsh/releases/download/v0.12.1+4/rddbsh-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "97c4a4939ea44ec4ca8c54a7489c19f87109de3fa7ac4300d206966a7f0cf60b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/winebarrel/rddbsh/releases/download/v0.12.1+4/rddbsh-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "379f68fe6f82d924b644dd3ec9f678032f95f8e0a24a4494e38752d3be36c1e3"
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
