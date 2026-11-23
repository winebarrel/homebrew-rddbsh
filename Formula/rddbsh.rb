class Rddbsh < Formula
  desc "A SQL-like interactive CLI for Amazon DynamoDB (Rust port of awslabs/dynamodb-shell)"
  homepage "https://github.com/winebarrel/rddbsh"
  version "0.12.1+1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/winebarrel/rddbsh/releases/download/v0.12.1+1/rddbsh-aarch64-apple-darwin.tar.xz"
    sha256 "2cfc585b4b0b1fd2cba5ff4bb0ff8bb5d2618e587d2af7d6e676fedc5469fb47"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/winebarrel/rddbsh/releases/download/v0.12.1+1/rddbsh-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3ed748c33b1f3d4931d11ac8f3507becae1118bc306703715c085bdbbdf853f8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/winebarrel/rddbsh/releases/download/v0.12.1+1/rddbsh-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4a65ad8dc0ea60dde42ecd4690e75f0828c786a6bd782785ae684448e0949d8e"
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
