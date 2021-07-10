class Pcre2 < Formula
  desc "Perl compatible regular expressions library with a new API"
  homepage "https://www.pcre.org/"
  url "https://ftp.pcre.org/pub/pcre/pcre2-10.37.tar.bz2"
  sha256 "4d95a96e8b80529893b4562be12648d798b957b1ba1aae39606bbc2ab956d270"
  head "svn://vcs.exim.org/pcre2/code/trunk"

  bottle do
    cellar :any
    root_url "https://autobrew.github.io/bottles"
    sha256 "9df4ad2c3ccb7df8677a18d2141a3b4af8207362f9c16e410955512776805971" => :high_sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-pcre2-16",
                          "--enable-pcre2-32",
                          "--enable-pcre2grep-libz",
                          "--enable-pcre2grep-libbz2",
                          "--enable-jit"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"pcre2grep", "regular expression", prefix/"README"
  end
end
