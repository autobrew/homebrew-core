class Freetype < Formula
  desc "Software library to render fonts"
  homepage "https://www.freetype.org/"
  url "https://downloads.sourceforge.net/project/freetype/freetype2/2.10.4/freetype-2.10.4.tar.xz"
  mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.10.4.tar.xz"
  sha256 "86a854d8905b19698bbc8f23b860bc104246ce4854dcea8e3b0fb21284f75784"

  bottle do
    cellar :any
    root_url "https://autobrew.github.io/bottles"
    sha256 "c9bc84cf271b1875333b3bca3b1fc51414ec24331460634690432355c5c9d78a" => :high_sierra
    sha256 "a9aa908276a422aa8f472510c0cb0dfdc3faa7cbaaf8e40dd46f77d2a2600158" => :el_capitan
  end

  depends_on "libpng"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-freetype-config",
                          "--without-harfbuzz"
    system "make"
    system "make", "install"

    inreplace [bin/"freetype-config", lib/"pkgconfig/freetype2.pc"],
      prefix, opt_prefix
  end

  test do
    system bin/"freetype-config", "--cflags", "--libs", "--ftversion",
                                  "--exec-prefix", "--prefix"
  end
end
