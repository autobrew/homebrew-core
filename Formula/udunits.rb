class Udunits < Formula
  desc "Unidata unit conversion library"
  homepage "https://www.unidata.ucar.edu/software/udunits/"
  url "https://github.com/Unidata/UDUNITS-2/archive/v2.2.27.6.tar.gz"
  sha256 "74fd7fb3764ce2821870fa93e66671b7069a0c971513bf1904c6b053a4a55ed1"
  revision 1

  bottle do
    cellar :any
    root_url "https://autobrew.github.io/bottles"
    sha256 "15a403c9e2aaf4062786fd0962e8cb44cfde23590c430c2aa0bbac465cbf2773" => :high_sierra
  end

  depends_on "cmake" => :build

  #uses_from_macos "expat"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
      system "make", "clean"
      system "cmake", "..", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
      system "make"
      lib.install "lib/libudunits2.a"
    end
  end

  test do
    assert_match(/1 kg = 1000 g/, shell_output("#{bin}/udunits2 -H kg -W g"))
  end
end
