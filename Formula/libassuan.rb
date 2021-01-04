class Libassuan < Formula
  desc "Assuan IPC Library"
  homepage "https://www.gnupg.org/related_software/libassuan/"
  url "https://gnupg.org/ftp/gcrypt/libassuan/libassuan-2.5.4.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libassuan/libassuan-2.5.4.tar.bz2"
  sha256 "c080ee96b3bd519edd696cfcebdecf19a3952189178db9887be713ccbcb5fbf0"

  bottle do
    cellar :any
    root_url "https://autobrew.github.io/bottles"
    sha256 "e0cb226b596b8a021b026b4a1e357949fe52763d9fb512092df98fcacf16dd97" => :el_capitan
    sha256 "c70981039e3febf01c6966ae8888942e0cbcd1ca6954c6b81804f306026cda68" => :high_sierra
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
