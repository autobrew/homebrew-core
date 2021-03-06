class Wdiff < Formula
  desc "Display word differences between text files"
  homepage "https://www.gnu.org/software/wdiff/"
  url "https://ftp.gnu.org/gnu/wdiff/wdiff-1.2.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/wdiff/wdiff-1.2.2.tar.gz"
  sha256 "34ff698c870c87e6e47a838eeaaae729fa73349139fc8db12211d2a22b78af6b"

  bottle do
    cellar :any_skip_relocation
#    sha256 "6efa01d5b01a7b3c1dfe4803c310e0cb1619fa93432ba0b34ee33ea310cb04b9" => :mojave
    sha256 "1c0d329ea782f64396dcef2420b9c90517dd8e8203fbddc924c37a5211e34a4d" => :high_sierra
    sha256 "aaeab2c70d214deb69451922276ea6d5450b78784cdea803c9cd1220a47998ed" => :sierra
    sha256 "2e3e40ebdb98e11d783fd5e8e9f5c7c553ae06c739b47a4cf3aa3c4c9483cdf2" => :el_capitan
    sha256 "1e34ac95a5aa21146f93c5bd0d7d1b22c48941101dc684d019d6d9700da90e8f" => :yosemite
    sha256 "6cf8260aaa5f0da951bf405f3ed05e1660f8ca7d585c11324319b0c1e6371d56" => :mavericks
    sha256 "06da8b4a640ef51d0dd884b436d3909c4bd2c5c00ea5da9e81158554a00f0dbe" => :mountain_lion
  end

  depends_on "gettext" => :optional

  conflicts_with "montage", :because => "Both install an mdiff executable"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-experimental"
    system "make", "install"
  end

  test do
    a = testpath/"a.txt"
    a.write "The missing package manager for OS X"

    b = testpath/"b.txt"
    b.write "The package manager for OS X"

    output = shell_output("#{bin}/wdiff #{a} #{b}", 1)
    assert_equal "The [-missing-] package manager for OS X", output
  end
end
