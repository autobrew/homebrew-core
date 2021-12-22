class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "https://people.engr.tamu.edu/davis/suitesparse.html"
  url "https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/v5.10.1.tar.gz"
  sha256 "acb4d1045f48a237e70294b950153e48dce5b5f9ca8190e86c2b8c54ce00a7ee"

  depends_on "cmake" => :build

  def install
    args = [
      "INSTALL=#{prefix}",
      "BLAS=-framework Accelerate",
      "LAPACK=$(BLAS)",
      "CHOLMOD_CONFIG=-DNPARTITION",
      "CMAKE_OPTIONS=#{std_cmake_args.join(" ")}",
      "JOBS=3",
    ]

    # Parallelism is managed through the `JOBS` make variable and not with `-j`.
    ENV.deparallelize
    system "make", "library", *args
    system "make", "install", *args
    bin.rmtree
    lib.rmtree
    lib.install Dir["**/*.a"]
    pkgshare.install "KLU/Demo/klu_simple.c"
  end

  test do
    system ENV.cc, "-o", "test", pkgshare/"klu_simple.c",
     "-L#{lib}", "-lsuitesparseconfig", "-lklu", "-lbtf", "-lcolamd", "-lamd"
    assert_predicate testpath/"test", :exist?
    assert_match "x [0] = 1", shell_output("./test")
  end
end
