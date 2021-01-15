class Udunits < Formula
  desc "Unidata unit conversion library"
  homepage "https://www.unidata.ucar.edu/software/udunits/"
  url "https://github.com/Unidata/UDUNITS-2/archive/v2.2.27.6.tar.gz"
  sha256 "74fd7fb3764ce2821870fa93e66671b7069a0c971513bf1904c6b053a4a55ed1"

  bottle do
    sha256 "3c12f59317ded4bdc6f89c24a0eec9260a499371c9c92b2d5e34c1b1a9f50a2c" => :high_sierra
  end

  depends_on "cmake" => :build

  #uses_from_macos "expat"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match(/1 kg = 1000 g/, shell_output("#{bin}/udunits2 -H kg -W g"))
  end
end
