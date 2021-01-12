class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://github.com/jasper-software/jasper/archive/version-2.0.24.tar.gz"
  sha256 "d2d28e115968d38499163cf8086179503668ce0d71b90dd33855b3de96a1ca1d"

  depends_on "cmake" => :build
  depends_on "jpeg"

  def install
    mkdir "build" do
      # Make sure macOS's GLUT.framework is used, not XQuartz or freeglut
      # Reported to CMake upstream 4 Apr 2016 https://gitlab.kitware.com/cmake/cmake/issues/16045
      glut_lib = "#{MacOS.sdk_path}/System/Library/Frameworks/GLUT.framework"

      system "cmake", "..",
        "-DGLUT_glut_LIBRARY=#{glut_lib}",
        "-DJAS_ENABLE_AUTOMATIC_DEPENDENCIES=false",
        *std_cmake_args
      system "make"
      system "make", "install"
      system "make", "clean"

      system "cmake", "..",
        "-DGLUT_glut_LIBRARY=#{glut_lib}",
        "-DJAS_ENABLE_SHARED=OFF",
        *std_cmake_args
      system "make"
      lib.install "src/libjasper/libjasper.a"
    end
  end

  test do
    system bin/"jasper", "--input", test_fixtures("test.jpg"),
                         "--output", "test.bmp"
    assert_predicate testpath/"test.bmp", :exist?
  end
end
