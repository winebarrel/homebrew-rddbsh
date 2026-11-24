class Rddbsh < Formula
  desc "A SQL-like interactive CLI for Amazon DynamoDB (Rust port of awslabs/dynamodb-shell)"
  homepage "https://github.com/winebarrel/rddbsh"
  version "0.12.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/winebarrel/rddbsh/releases/download/v0.12.2/rddbsh-aarch64-apple-darwin.tar.xz"
    sha256 "bc876c70078cf497e946b79b9cfd038a9ae66a43b4f02026c190195469034277"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/winebarrel/rddbsh/releases/download/v0.12.2/rddbsh-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2b2382efe45ab39f8171c7bc5babd11582ba9f0a7c04a2d04bc9b8be161df507"
    end
    if Hardware::CPU.intel?
      url "https://github.com/winebarrel/rddbsh/releases/download/v0.12.2/rddbsh-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "aa17979f060d663c1850e07f472c178ea7d08b9520023f733c021c631cf9af14"
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
