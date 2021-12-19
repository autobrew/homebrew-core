class Thrift < Formula
  desc "Framework for scalable cross-language services development"
  homepage "https://thrift.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=thrift/0.15.0/thrift-0.15.0.tar.gz"
  mirror "https://archive.apache.org/dist/thrift/0.15.0/thrift-0.15.0.tar.gz"
  sha256 "d5883566d161f8f6ddd4e21f3a9e3e6b8272799d054820f1c25b11e86718f86b"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  bottle do
    cellar :any_skip_relocation
    root_url "https://autobrew.github.io/bottles"
    sha256 "aac88290c8f911e563d4e69ac61481799fbdcb7a3b0fd6919e6ad4f96621d8e9" => :high_sierra
  end

  head do
    url "https://github.com/apache/thrift.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
  end

  option "with-haskell", "Install Haskell binding"
  option "with-erlang", "Install Erlang binding"
  option "with-java", "Install Java binding"
  option "with-perl", "Install Perl binding"
  option "with-php", "Install PHP binding"
  option "with-libevent", "Install nonblocking server libraries"

  deprecated_option "with-python" => "with-python@2"

  depends_on "bison" => :build
  depends_on "boost" => :build
  depends_on "openssl"
  depends_on "libevent" => :optional
  depends_on "python@2" => :optional

  if build.with? "java"
    depends_on "ant" => :build
    depends_on :java => "1.8"
  end

  def install
    system "./bootstrap.sh" unless build.stable?

    exclusions = ["--without-ruby", "--disable-tests", "--without-php_extension"]
    exclusions << "--without-swift"

    exclusions << "--without-python" if build.without? "python@2"
    exclusions << "--without-haskell" if build.without? "haskell"
    exclusions << "--without-java" if build.without? "java"
    exclusions << "--without-perl" if build.without? "perl"
    exclusions << "--without-php" if build.without? "php"
    exclusions << "--without-erlang" if build.without? "erlang"

    ENV.cxx11 if MacOS.version >= :mavericks && ENV.compiler == :clang

    # Don't install extensions to /usr:
    ENV["PY_PREFIX"] = prefix
    ENV["PHP_PREFIX"] = prefix
    ENV["JAVA_PREFIX"] = buildpath

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}",
                          *exclusions
    ENV.deparallelize
    system "make"
    system "make", "install"

    # Even when given a prefix to use it creates /usr/local/lib inside
    # that dir & places the jars there, so we need to work around that.
    (pkgshare/"java").install Dir["usr/local/lib/*.jar"] if build.with? "java"
  end

  def caveats; <<~EOS
    To install Ruby binding:
      gem install thrift
  EOS
  end

  test do
    system "#{bin}/thrift", "--version"
  end
end
