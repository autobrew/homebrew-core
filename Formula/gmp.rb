class Gmp < Formula
  desc "GNU multiple precision arithmetic library"
  homepage "https://gmplib.org/"
  url "https://gmplib.org/download/gmp/gmp-6.2.1.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.xz"
  sha256 "fd4829912cddd12f84181c3451cc752be224643e87fac497b69edddadc49b4f2"

  bottle do
    cellar :any
    root_url "https://autobrew.github.io/bottles"
    sha256 "30c0a3a9f0e03ad9752bf473bb28a0a828a582e28fe083b292a5e362455f1ad5" => :high_sierra
    sha256 "64589935f2a43c3aa3cb7269801c0a6c10f15062d453601ab71fd551632e5873" => :el_capitan
  end

  patch do
    url "https://gmplib.org/repo/gmp/raw-rev/5f32dbc41afc"
    sha256 "a44ef57903b240df6fde6c9d2fe40063f785995c43b6bfc7a237c571f53613e0"
  end

  def install
    # Enable --with-pic to avoid linking issues with the static library
    args = %W[--prefix=#{prefix} --enable-cxx --with-pic]
    args << "--build=core2-apple-darwin#{`uname -r`.to_i}" if build.bottle?
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gmp.h>
      #include <stdlib.h>
      int main() {
        mpz_t i, j, k;
        mpz_init_set_str (i, "1a", 16);
        mpz_init (j);
        mpz_init (k);
        mpz_sqrtrem (j, k, i);
        if (mpz_get_si (j) != 5 || mpz_get_si (k) != 1) abort();
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-lgmp", "-o", "test"
    system "./test"

    # Test the static library to catch potential linking issues
    system ENV.cc, "test.c", "#{lib}/libgmp.a", "-o", "test"
    system "./test"
  end
end
