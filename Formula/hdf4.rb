class Hdf4 < Formula
  desc "Legacy HDF4 driver for GDAL"
  homepage "https://www.hdfgroup.org"
  url "https://support.hdfgroup.org/ftp/HDF/releases/HDF4.2.15/src/hdf-4.2.15.tar.gz"
  sha256 "dbeeef525af7c2d01539906c28953f0fdab7dba603d1bc1ec4a5af60d002c459"

  bottle do
    cellar :any
    root_url "https://autobrew.github.io/bottles"
    sha256 "0c6b89b04d458dbec257b3d8702459b8d1168a8edda4c93b7701a5f804fdebc2" => :high_sierra
  end

  depends_on "gcc" => :build
  depends_on "jpeg"
  depends_on "szip"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-szlib=#{Formula["szip"].opt_prefix}
      --enable-build-mode=production
      --enable-fortran
      --disable-netcdf
      --disable-deprecated-symbols
    ]
    system "./configure", *args
    system "make", "install"
  end
end
