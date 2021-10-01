class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "http://zstd.net/"
  url "https://github.com/facebook/zstd/releases/download/v1.5.0/zstd-1.5.0.tar.gz"
  sha256 "5194fbfa781fcf45b98c5e849651aa7b3b0a008c6b72d4a0db760f3002291e94"

  bottle do
    cellar :any
    sha256 "2380f8e4de1df9ab047a3acbdfe8b0c046ef4fc42bf64ada8d264ed5381c4255" => :high_sierra
    sha256 "99cba2f60365eeb883dafd6b69ca4eb353014020a6fd3e979a377e56dd8d812f" => :el_capitan
    root_url "https://autobrew.github.io/bottles"
  end

  option "without-pzstd", "Build without parallel (de-)compression tool"

  depends_on "cmake" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}/"

    if build.with? "pzstd"
      system "make", "-C", "contrib/pzstd", "googletest"
      system "make", "-C", "contrib/pzstd", "PREFIX=#{prefix}"
      bin.install "contrib/pzstd/pzstd"
    end
  end

  test do
    assert_equal "hello\n",
      pipe_output("#{bin}/zstd | #{bin}/zstd -d", "hello\n", 0)

    if build.with? "pzstd"
      assert_equal "hello\n",
        pipe_output("#{bin}/pzstd | #{bin}/pzstd -d", "hello\n", 0)
    end
  end
end
