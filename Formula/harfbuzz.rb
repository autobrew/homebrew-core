class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://wiki.freedesktop.org/www/Software/HarfBuzz/"
  url "https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-2.3.1.tar.bz2"
  sha256 "f205699d5b91374008d6f8e36c59e419ae2d9a7bb8c5d9f34041b9a5abcae468"

  bottle do
    cellar :any
    root_url "https://jeroen.github.io/bottles"
    sha256 "86218514b0bb7b9825eac4d7e28f614d1635c55f92edf473fcb222c2906fbcf9" => :el_capitan
  end

  head do
    url "https://github.com/behdad/harfbuzz.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "ragel" => :build
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "freetype"
  depends_on "glib"

  resource "ttf" do
    url "https://github.com/behdad/harfbuzz/raw/fc0daafab0336b847ac14682e581a8838f36a0bf/test/shaping/fonts/sha1sum/270b89df543a7e48e206a2d830c0e10e5265c630.ttf"
    sha256 "9535d35dab9e002963eef56757c46881f6b3d3b27db24eefcc80929781856c77"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-introspection=no
      --enable-static
      --with-cairo=yes
      --with-coretext=yes
      --with-freetype=yes
      --with-glib=yes
      --with-gobject=no
      --with-graphite2=no
      --with-icu=no
    ]

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    resource("ttf").stage do
      shape = `echo 'സ്റ്റ്' | #{bin}/hb-shape 270b89df543a7e48e206a2d830c0e10e5265c630.ttf`.chomp
      assert_equal "[glyph201=0+1183|U0D4D=0+0]", shape
    end
  end
end
