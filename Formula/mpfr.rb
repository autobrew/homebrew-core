class Mpfr < Formula
  desc "C library for multiple-precision floating-point computations"
  homepage "https://www.mpfr.org/"
  url "http://ftp.gnu.org/gnu/mpfr/mpfr-4.1.0.tar.xz"
  mirror "http://ftpmirror.gnu.org/mpfr/mpfr-4.1.0.tar.xz"
  sha256 "0c98a3f1732ff6ca4ea690552079da9c597872d30e96ec28414ee23c95558a7f"

  bottle do
    cellar :any
    root_url "https://autobrew.github.io/bottles"
    sha256 "88d8114b301d7563131d71c0245ffd612becac8601edfc661634906b52f815b4" => :high_sierra
    sha256 "9a494b5425de77070c596e9e2be3b501aafcea42e47b27960b656414194e71b6" => :el_capitan
  end

  depends_on "gmp"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--disable-silent-rules"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mpfr.h>
      #include <math.h>
      #include <stdlib.h>
      int main() {
        mpfr_t x, y;
        mpfr_inits2 (256, x, y, NULL);
        mpfr_set_ui (x, 2, MPFR_RNDN);
        mpfr_root (y, x, 2, MPFR_RNDN);
        mpfr_pow_si (x, y, 4, MPFR_RNDN);
        mpfr_add_si (y, x, -4, MPFR_RNDN);
        mpfr_abs (y, y, MPFR_RNDN);
        if (fabs(mpfr_get_d (y, MPFR_RNDN)) > 1.e-30) abort();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-L#{Formula["gmp"].opt_lib}",
                   "-lgmp", "-lmpfr", "-o", "test"
    system "./test"
  end
end
