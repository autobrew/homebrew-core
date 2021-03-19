class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://www.imagemagick.org/"
  # Please always keep the Homebrew mirror as the primary URL as the
  # ImageMagick site removes tarballs regularly which means we get issues
  # unnecessarily and older versions of the formula are broken.
  url "https://dl.bintray.com/homebrew/mirror/ImageMagick-6.9.12-3.tar.xz"
  mirror "https://www.imagemagick.org/download/releases/ImageMagick-6.9.12-3.tar.xz"
  sha256 "b9bf05a49f878713d96bc9c88d21414adaf2a542125530e2dee8a07128ef8ed1"
  head "https://github.com/imagemagick/imagemagick6.git"

  bottle do
    cellar :any
    root_url "https://autobrew.github.io/bottles"
    sha256 "01c692862ff5b2fc4e205ed30d83748303930df48bef3d61962f6acf990639d7" => :el_capitan
    sha256 "f650cbe2d8269783c1c0954fcf924d278f6af0b88a1652048d9b5532347fe982" => :high_sierra
  end

  keg_only :versioned_formula

  # Hardcode thresholds.xml
  patch do
    url "https://patch-diff.githubusercontent.com/raw/ImageMagick/ImageMagick6/pull/141.diff"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext" => :test # via cairo
  depends_on "libtool"
  depends_on "xz"
  depends_on "jpeg"
  depends_on "libheif"
  depends_on "libpng"
  depends_on "libraw"
  depends_on "libtiff"
  depends_on "freetype"
  depends_on "fontconfig"
  depends_on "librsvg"
  depends_on "openjpeg"
  depends_on "pango"
  depends_on "webp"

  def install
    args = %W[
      --disable-osx-universal-binary
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-shared
      --enable-static
      --with-freetype
      --with-fontconfig
      --with-openjp2
      --with-webp
      --with-pango
      --with-rsvg
      --with-libraw
      --with-heic
      --without-x
      --without-wmf
      --without-modules
      --without-gslib
      --without-openmp
      --without-fftw
      --without-perl
      --enable-zero-configuration
      --with-gs-font-dir=/usr/local/share/ghostscript/fonts
    ]

    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_BASE_VERSION}", "${PACKAGE_NAME}"
    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "PNG", shell_output("#{bin}/identify #{test_fixtures("test.png")}")
    # Check support for recommended features and delegates.
    features = shell_output("#{bin}/convert -version")
    %w[raw heic fontconfig pango cairo rsvg webp freetype jpeg jp2 png tiff].each do |feature|
      assert_match feature, features
    end
  end
end
