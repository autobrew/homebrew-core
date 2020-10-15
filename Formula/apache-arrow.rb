class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  # url "https://downloads.apache.org/arrow/arrow-2.0.0/apache-arrow-2.0.0.tar.gz"
  # Uncomment and update to test on a release candidate 
  url "https://dist.apache.org/repos/dist/dev/arrow/apache-arrow-2.0.0-rc2/apache-arrow-2.0.0.tar.gz"
  sha256 "be0342cc847bb340d86aeaef43596a0b6c1dbf1ede9c789a503d939e01c71fbe"
  
  bottle do
    cellar :any
    sha256 "7e1600cc98244a80b3567da2eed8a36922fb2faea6ef4e6b9bc74ee40d720bab" => :high_sierra
    sha256 "c0703750b7d3d21d6156db590caecdf0a899674db57abb88ac3eff6e10d265de" => :el_capitan
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
      -DARROW_USE_GLOG=OFF
      -DARROW_RUNTIME_SIMD_LEVEL=AVX2
      -DARROW_PYTHON=OFF
      -DARROW_S3=ON
      -DARROW_WITH_LZ4=ON
      -DARROW_WITH_SNAPPY=ON
      -DARROW_WITH_UTF8PROC=OFF
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
