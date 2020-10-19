class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://downloads.apache.org/arrow/arrow-2.0.0/apache-arrow-2.0.0.tar.gz"
  # Uncomment and update to test on a release candidate 
  # url "https://dist.apache.org/repos/dist/dev/arrow/apache-arrow-2.0.0-rc2/apache-arrow-2.0.0.tar.gz"
  sha256 "be0342cc847bb340d86aeaef43596a0b6c1dbf1ede9c789a503d939e01c71fbe"
  
  patch do
    # Properly detect (lack of) avx512 support
    url "https://github.com/apache/arrow/commit/bbe4bd3c9c158fb05d2d0a830e631918ad825529.patch"	
  end
  
  bottle do
    cellar :any
    sha256 "ea976b3c83e5507128c30dfe226567ac4997ef2b35bc13645d3429d78c87be3f" => :high_sierra
    sha256 "b5f28aa64b96d876308ba1feddda0f2ccca6fa11068e6d24eb5045022bded55d" => :el_capitan
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
