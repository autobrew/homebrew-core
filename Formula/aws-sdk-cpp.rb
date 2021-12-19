class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.9.163",
      revision: "6140db4ffa9ae018a2a9b94b43d07d011dae006b"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    rebuild 2
    cellar :any_skip_relocation
    sha256 "bdb323d0956096e8ab96e1e6d27252607117983e80cf661ff39644b978b8cb99" => :high_sierra
    root_url "https://autobrew.github.io/bottles"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_SHARED_LIBS=OFF", "-DBUILD_ONLY=config;s3;transfer;identity-management;sts", "-DENABLE_UNITY_BUILD=ON",  *std_cmake_args
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
