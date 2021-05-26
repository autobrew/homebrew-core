class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://downloads.apache.org/arrow/arrow-4.0.1/apache-arrow-4.0.1.tar.gz"
  # Uncomment and update to test on a release candidate 
  # url "https://dist.apache.org/repos/dist/dev/arrow/apache-arrow-4.0.1-rc1/apache-arrow-4.0.1.tar.gz"
  sha256 "75ccbfa276b925c6b1c978a920ff2f30c4b0d3fdf8b51777915b6f69a211896e"

  bottle do
    cellar :any
    sha256 "e2366b8a111fe021b3b745a73746d77b411090610cd66768b1829f8af78a8797" => :high_sierra
    sha256 "dc85e27a5ff80e812da4976c38bda7a782d1ee283399db19255d63698794d298" => :el_capitan
    root_url "https://autobrew.github.io/bottles"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "aws-sdk-cpp"
  depends_on "lz4"
  depends_on "thrift"
  depends_on "snappy"
  depends_on "zstd"

  def install
    ENV.cxx11
    args = %W[
      -DARROW_COMPUTE=ON
      -DARROW_CSV=ON
      -DARROW_DATASET=ON
      -DARROW_FILESYSTEM=ON
      -DARROW_HDFS=OFF
      -DARROW_JSON=ON
      -DARROW_PARQUET=ON
      -DARROW_BUILD_SHARED=OFF
      -DARROW_JEMALLOC=ON
      -DARROW_MIMALLOC=ON
      -DARROW_USE_GLOG=OFF
      -DARROW_PYTHON=OFF
      -DARROW_S3=ON
      -DARROW_WITH_LZ4=ON
      -DARROW_WITH_SNAPPY=ON
      -DARROW_WITH_ZLIB=ON
      -DARROW_WITH_ZSTD=ON
      -DARROW_BUILD_UTILITIES=ON
      -DCMAKE_UNITY_BUILD=OFF
      -DPARQUET_BUILD_EXECUTABLES=ON
      -DLZ4_HOME=#{Formula["lz4"].prefix}
      -DTHRIFT_HOME=#{Formula["thrift"].prefix}
    ]

    mkdir "build"
    cd "build" do
      system "cmake", "../cpp", *std_cmake_args, *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "arrow/api.h"
      int main(void) {
        arrow::int64();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}", "-larrow", "-larrow_bundled_dependencies", "-o", "test"
    system "./test"
  end
end
