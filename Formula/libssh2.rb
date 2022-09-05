class Libssh2 < Formula
  desc "C library implementing the SSH2 protocol"
  homepage "https://libssh2.org/"
  url "https://github.com/libssh2/libssh2.git",
      :revision => "6c59eea5a9ea77127ec0fa3d6815c8adc743dba3"
  version "1.10.1"

  bottle do
    cellar :any
    root_url "https://autobrew.github.io/bottles"
    sha256 "f5e9abfe13cbea489ab11d5a7c5704d29b5c7c2f74921c32b1db908cc0c38a3b" => :high_sierra
    sha256 "a0ab62111867ff1e87077ee8c82fd3fcde3d0d3a1771de4422eb05160486c973" => :el_capitan
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
