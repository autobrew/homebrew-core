class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.15.0.tar.bz2"
  sha256 "0b472bc12c7d455906c8a539ec56da0a6480ef1c3a87aa5b74d7125df68d0e5b"

  bottle do
    root_url "https://autobrew.github.io/bottles"
    sha256 "39236fd4ad9d2ee1e3e535afe945133706f1b4133371e459c61d033b990310c4" => :el_capitan
    sha256 "b1041937d74e7911fdb683b27d24e7c0e2d216433591907520658531e2931c93" => :high_sierra
  end

  depends_on "swig" => :build
  depends_on "gnupg"
  depends_on "libassuan"
  depends_on "libgpg-error"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"gpgme-config", prefix, opt_prefix
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gpgme-tool --lib-version")
    system "python2.7", "-c", "import gpg; print gpg.version.versionstr"
  end
end
