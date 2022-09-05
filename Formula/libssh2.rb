class Libssh2 < Formula
  desc "C library implementing the SSH2 protocol"
  homepage "https://libssh2.org/"
  url "https://github.com/libssh2/libssh2.git",
      :revision => "6c59eea5a9ea77127ec0fa3d6815c8adc743dba3"
  version "1.10.1"

  bottle do
    cellar :any
    root_url "https://autobrew.github.io/bottles"
    sha256 "dfcbd5dd5dd25299fbc6c90065061d12e5b5a8b9caacce5249370a58b652922b" => :high_sierra
  end

  head do
    url "https://github.com/libssh2/libssh2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # Build from git for now: https://github.com/libssh2/libssh2/issues/536#issuecomment-892897873
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-examples-build
      --with-openssl
      --with-libz
      --with-libssl-prefix=#{Formula["openssl@1.1"].opt_prefix}
    ]

    system "autoreconf -fi"
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libssh2.h>

      int main(void)
      {
      libssh2_exit();
      return 0;
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-lssh2", "-o", "test"
    system "./test"
  end
end
