class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "https://facebook.github.io/zstd/"
  url "https://github.com/facebook/zstd/archive/v1.4.5.tar.gz"
  sha256 "734d1f565c42f691f8420c8d06783ad818060fc390dee43ae0a89f86d0a4f8c2"

  bottle do
    cellar :any
    sha256 "61de5a45183f4d029c66024d645ad44b0a625d58f9f583b47af42346a7c90fe5" => :high_sierra
  end

  depends_on "cmake" => :build

  #uses_from_macos "zlib"

  def install
    system "make", "install", "PREFIX=#{prefix}/"

    # Build parallel version
    system "make", "-C", "contrib/pzstd", "googletest"
    system "make", "-C", "contrib/pzstd", "PREFIX=#{prefix}"
    bin.install "contrib/pzstd/pzstd"
  end

  test do
    assert_equal "hello\n",
      pipe_output("#{bin}/zstd | #{bin}/zstd -d", "hello\n", 0)

    assert_equal "hello\n",
      pipe_output("#{bin}/pzstd | #{bin}/pzstd -d", "hello\n", 0)
  end
end
