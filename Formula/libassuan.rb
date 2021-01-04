class Libassuan < Formula
  desc "Assuan IPC Library"
  homepage "https://www.gnupg.org/related_software/libassuan/"
  url "https://gnupg.org/ftp/gcrypt/libassuan/libassuan-2.5.4.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libassuan/libassuan-2.5.4.tar.bz2"
  sha256 "c080ee96b3bd519edd696cfcebdecf19a3952189178db9887be713ccbcb5fbf0"

  bottle do
    cellar :any
#    sha256 "3734fe43c829fd0586e71c1f458a87d5485bdef24db4d63541995d0ff1d8495e" => :mojave
    sha256 "a05af2506efccbd153b216c2ed6b17c7b28b1c50fce16489166782877695b8ee" => :high_sierra
    sha256 "3aefafdbaf62a8319b618c73654aef88f9ebe8b9cba51a304aebaa09bfc92c4c" => :sierra
    sha256 "6e4ef55130d531e2e24226379f70c6ea59e62caf4fcc8fabffdecf8b2a0d018e" => :el_capitan
  end

  depends_on "libgpg-error"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"libassuan-config", prefix, opt_prefix
  end

  test do
    system bin/"libassuan-config", "--version"
  end
end
