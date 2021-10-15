class Fftw < Formula
  desc "C routines to compute the Discrete Fourier Transform"
  homepage "https://www.fftw.org"
  url "https://fftw.org/fftw-3.3.10.tar.gz"
  sha256 "56c932549852cddcfafdab3820b0200c7742675be92179e59e6215b340e26467"

  bottle do
    cellar :any
    root_url "https://autobrew.github.io/bottles"
    sha256 "7e8767b9136cd6da8c60ba7163e61eec66040319f2e0c85e8e001aceb47a484b" => :high_sierra
  end

  option "with-mpi", "Enable MPI parallel transforms"
  option "with-openmp", "Enable OpenMP parallel transforms"
  option "without-fortran", "Disable Fortran bindings"

  depends_on "gcc" if build.with?("fortran") || build.with?("openmp")

  depends_on "open-mpi" if build.with? "mpi"

  fails_with :clang if build.with? "openmp"

  def install
    args = ["--enable-shared",
            "--disable-debug",
            "--prefix=#{prefix}",
            "--enable-threads",
            "--disable-dependency-tracking"]
    simd_args = ["--enable-sse2"]
    simd_args << "--enable-avx" if ENV.compiler == :clang && Hardware::CPU.avx? && !build.bottle?
    simd_args << "--enable-avx2" if ENV.compiler == :clang && Hardware::CPU.avx2? && !build.bottle?

    args << "--disable-fortran" if build.without? "fortran"
    args << "--enable-mpi" if build.with? "mpi"
    args << "--enable-openmp" if build.with? "openmp"

    # single precision
    # enable-sse2, enable-avx and enable-avx2 work for both single and double precision
    #system "./configure", "--enable-single", *(args + simd_args)
    #system "make", "install"

    # clean up so we can compile the double precision variant
    #system "make", "clean"

    # double precision
    # enable-sse2, enable-avx and enable-avx2 work for both single and double precision
    system "./configure", *(args + simd_args)
    system "make", "install"

    # clean up so we can compile the long-double precision variant
    #system "make", "clean"

    # long-double precision
    # no SIMD optimization available
    #system "./configure", "--enable-long-double", *args
    #system "make", "install"
  end

  test do
    # Adapted from the sample usage provided in the documentation:
    # http://www.fftw.org/fftw3_doc/Complex-One_002dDimensional-DFTs.html
    (testpath/"fftw.c").write <<~EOS
      #include <fftw3.h>
      int main(int argc, char* *argv)
      {
          fftw_complex *in, *out;
          fftw_plan p;
          long N = 1;
          in = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * N);
          out = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * N);
          p = fftw_plan_dft_1d(N, in, out, FFTW_FORWARD, FFTW_ESTIMATE);
          fftw_execute(p); /* repeat as needed */
          fftw_destroy_plan(p);
          fftw_free(in); fftw_free(out);
          return 0;
      }
    EOS

    system ENV.cc, "-o", "fftw", "fftw.c", "-L#{lib}", "-lfftw3", *ENV.cflags.to_s.split
    system "./fftw"
  end
end
