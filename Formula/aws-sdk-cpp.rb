class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/1.7.365.tar.gz"
  sha256 "95e3f40efaea7b232741bfb76c54c9507c02631edfc198720b0e84be0ebb5e9d"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    sha256 "5b894fdbfc1d2d2b6c54a0a8fe2d53953b43cafd6ec93741fc4235ac9ee406e4" => :catalina
    sha256 "2d9f1f2aabe30948e7751fe97f86307ae00cd6db6d4d0b7b892e01acaedba839" => :mojave
    sha256 "043111013037afbbc86d155d45a2dcb56c213577faa61839b79ee6a76fb8e00e" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_SHARED_LIBS=OFF", "-DBUILD_ONLY=s3;core;config", "-DENABLE_UNITY_BUILD=ON",  *std_cmake_args
      system "make"
      system "make", "install"
    end

    lib.install Dir[lib/"mac/Release/*"].select { |f| File.file? f }
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <aws/core/Version.h>
      #include <iostream>

      int main() {
          std::cout << Aws::Version::GetVersionString() << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laws-cpp-sdk-core", "-lcurl",
           "-o", "test"
    system "./test"
  end
end
