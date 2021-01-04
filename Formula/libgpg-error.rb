class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.41.tar.bz2"
  sha256 "64b078b45ac3c3003d7e352a5e05318880a5778c42331ce1ef33d1a0d9922742"

  bottle do
    cellar :any
    root_url "https://autobrew.github.io/bottles"
    sha256 "ff8ce07cbd42111ec985f46f367f5cb884126263316d5aeb36a9e06aac61f252" => :el_capitan
    sha256 "a5425733af86d25cd9554b93dacc8698a168e3f6b40d07c27d61bbec961957fa" => :high_sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"gpg-error-config", prefix, opt_prefix
  end

  test do
    system "#{bin}/gpg-error-config", "--libs"
  end
end
