class Geos < Formula
  desc "Geometry Engine"
  homepage "https://trac.osgeo.org/geos"
  url "https://download.osgeo.org/geos/geos-3.9.1.tar.bz2"
  sha256 "7e630507dcac9dc07565d249a26f06a15c9f5b0c52dd29129a0e3d381d7e382a"

  bottle do
    cellar :any
    sha256 "d34ea2e3316cf9e1afdd89932168285985a1ca5790ae996c6fdba2df11e5621a" => :high_sierra
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
