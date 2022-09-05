class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v1.4.2.tar.gz"
  sha256 "901c2b4492976b86477569502a41c31b274b69adc177149c02099ea88404ef19"
  head "https://github.com/libgit2/libgit2.git"

  bottle do
    cellar :any
    root_url "https://autobrew.github.io/bottles"
    sha256 "ba666dd9b1121dba6ad258a2715461a4c6abcd9c02296a872436f6dbe3ebedbe" => :el_capitan
    sha256 "16b7f2b6fec4231ee36049994e2e02a9bab1797c20deaa4bb9f40e24b6fd20e0" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libssh2"

  def install
    args = std_cmake_args
    args << "-DBUILD_EXAMPLES=YES"
    args << "-DBUILD_TESTS=OFF" # Don't build tests.
    args << "-DUSE_SSH=YES"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
      cd "examples" do
        (pkgshare/"examples").install "lg2"
      end
      system "make", "clean"
      system "cmake", "..", "-DBUILD_SHARED_LIBS=OFF", *args
      system "make"
      lib.install "libgit2.a"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <git2.h>
      int main(int argc, char *argv[]) {
        int options = git_libgit2_features();
        return 0;
      }
    EOS
    libssh2 = Formula["libssh2"]
    flags = %W[
      -I#{include}
      -I#{libssh2.opt_include}
      -L#{lib}
      -lgit2
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
