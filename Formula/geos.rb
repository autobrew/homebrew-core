class Geos < Formula
  desc "Geometry Engine"
  homepage "https://trac.osgeo.org/geos"
  url "https://download.osgeo.org/geos/geos-3.9.1.tar.bz2"
  sha256 "7e630507dcac9dc07565d249a26f06a15c9f5b0c52dd29129a0e3d381d7e382a"

  bottle do
    cellar :any
    root_url "https://autobrew.github.io/bottles"
    sha256 "be0802809ba01d6508780f24ac5cba78d480be9e6a1f649be8979ff04d3aec63" => :high_sierra
  end

  depends_on "swig" => :build
  depends_on "python" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-python",
                          "PYTHON=#{Formula["python"].opt_bin}/python3"
    system "make", "install"
  end

  test do
    system "#{bin}/geos-config", "--libs"
  end
end
