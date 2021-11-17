class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.16.0.tar.bz2"
  sha256 "6c8cc4aedb10d5d4c905894ba1d850544619ee765606ac43df7405865de29ed0"

  bottle do
    root_url "https://autobrew.github.io/bottles"
    sha256 "39236fd4ad9d2ee1e3e535afe945133706f1b4133371e459c61d033b990310c4" => :el_capitan
    sha256 "b1041937d74e7911fdb683b27d24e7c0e2d216433591907520658531e2931c93" => :high_sierra
  end

  depends_on "swig" => :build
  depends_on "gnupg"
  depends_on "libassuan"
  depends_on "libgpg-error"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static",
                          "--disable-gpgconf-test",
                          "--disable-gpg-test"
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
