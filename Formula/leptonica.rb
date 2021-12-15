class Leptonica < Formula
  desc "Image processing and image analysis library"
  homepage "http://www.leptonica.org/"
  url "http://www.leptonica.org/source/leptonica-1.82.0.tar.gz"
  sha256 "155302ee914668c27b6fe3ca9ff2da63b245f6d62f3061c8f27563774b8ae2d6"

  bottle do
    cellar :any
#    sha256 "9fe1fcbf9d6a5b6770f41b238221f251485680649cd8751aef32bca61b4ae4f3" => :mojave
    sha256 "344103405f8861f37a93e0500b47e9f9c755689db3e90e5eb6b3a33299f70af9" => :high_sierra
    sha256 "35a0d7bdd7054e4ab59b8f40144f6a686f8a90f2773fe5463d3d6ef341fdcc66" => :sierra
    sha256 "de45c709e91297e100e645f795bcecdb884a2c00e88505313cb8339fb435fe26" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "giflib"
  depends_on "openjpeg"
  depends_on "webp"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    %w[libpng jpeg libtiff giflib openjpeg webp].each do |dep|
      args << "--with-lib#{dep}"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <leptonica/allheaders.h>

      int main(int argc, char **argv) {
          std::fprintf(stdout, "%d.%d.%d", LIBLEPT_MAJOR_VERSION, LIBLEPT_MINOR_VERSION, LIBLEPT_PATCH_VERSION);
          return 0;
      }
    EOS

    flags = ["-I#{include}/leptonica"] + ENV.cflags.to_s.split
    system ENV.cxx, "test.cpp", *flags
    assert_equal version.to_s, `./a.out`
  end
end
