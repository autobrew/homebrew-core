class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://downloads.apache.org/arrow/arrow-13.0.0/apache-arrow-13.0.0.tar.gz"
  # Uncomment and update to test on a release candidate 
  mirror "https://dist.apache.org/repos/dist/dev/arrow/apache-arrow-13.0.0-rc3/apache-arrow-13.0.0.tar.gz"
  sha256 "35dfda191262a756be934eef8afee8d09762cad25021daa626eb249e251ac9e6"

  bottle do
    cellar :any
    sha256 "1470bf4feb8069593dce149446e5d87ad461dfab7afba5514bed4f43d6bbd89c" => :high_sierra
    root_url "https://autobrew.github.io/bottles"
  end

  depends_on "boost" => :build
  depends_on "brotli"
  depends_on "cmake" => :build
  depends_on "aws-sdk-cpp"
  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "thrift"
  depends_on "snappy"
  depends_on "zstd"

  def install
    args = %W[
      -DARROW_ACERO=ON
      -DARROW_COMPUTE=ON
      -DARROW_CSV=ON
      -DARROW_CXXFLAGS="-D_LIBCPP_DISABLE_AVAILABILITY"
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
      -DARROW_GCS=ON
      -DARROW_WITH_BROTLI=ON
      -DARROW_WITH_BZ2=ON
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
    system ENV.cxx, "test.cpp", "-std=c++17", "-D_LIBCPP_DISABLE_AVAILABILITY", "-I#{include}", "-L#{lib}", "-larrow", "-larrow_bundled_dependencies", "-o", "test"
    system "./test"
  end
end
