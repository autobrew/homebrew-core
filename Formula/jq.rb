class Jq < Formula
  desc "Lightweight and flexible command-line JSON processor"
  homepage "https://stedolan.github.io/jq/"
  url "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-1.6.tar.gz"
  sha256 "5de8c8e29aaa3fb9cc6b47bb27299f271354ebb72514e3accadc7d38b5bbaa72"

  bottle do
    cellar :any
    root_url "https://autobrew.github.io/bottles"
    sha256 "79d8dfa28401f34a109a1f4dbe3b904ae4e46df101e377595ab7a64df9e98968" => :el_capitan
    sha256 "de37895f7198b24f2f1e5b3c262d10f15c9cb9bd98815c4c3850a4775eb4d34c" => :high_sierra
  end

  head do
    url "https://github.com/stedolan/jq.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "oniguruma"

  def install
    system "autoreconf", "-iv" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-maintainer-mode",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "2\n", pipe_output("#{bin}/jq .bar", '{"foo":1, "bar":2}')
  end
end
