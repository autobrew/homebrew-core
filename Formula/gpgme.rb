class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.15.0.tar.bz2"
  sha256 "0b472bc12c7d455906c8a539ec56da0a6480ef1c3a87aa5b74d7125df68d0e5b"

  bottle do
    cellar :any
    rebuild 1
    root_url "https://autobrew.github.io/bottles"
    sha256 "74b6fbc400e6b513cd42cfe8ab2379097dea11dadeb22b814d940c49e9ee06df" => :el_capitan
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
