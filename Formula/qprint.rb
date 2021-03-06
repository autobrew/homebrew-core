class Qprint < Formula
  desc "Encoder and decoder for quoted-printable encoding"
  homepage "https://www.fourmilab.ch/webtools/qprint"
  url "https://www.fourmilab.ch/webtools/qprint/qprint-1.1.tar.gz"
  sha256 "ffa9ca1d51c871fb3b56a4bf0165418348cf080f01ff7e59cd04511b9665019c"

  bottle do
    cellar :any_skip_relocation
#    sha256 "0915aa3e8b8481b717c4c84b0eda595821ecc99c9ffdcd0aa3e4952a3de9ae87" => :mojave
    sha256 "57950dba66674d62c84076374427f6c3de6d8cda81448c50b579c11b1b1959e4" => :high_sierra
    sha256 "f26387daf3d025dd45843784dd90fb3bf77609bdf0eb870f1b66782c89571950" => :sierra
    sha256 "9660443356a1f9571b39ea496349482e17f7c0d06829dd06945ca7680291c0bf" => :el_capitan
    sha256 "92470bcb0bd97c4d13181969ebeb0339faa85338ad139bf4a5ac19550635f5c1" => :yosemite
    sha256 "fbf2eadbf60b30557e3741e28545070bb377602aa8f1c1c49b5f65375381a2c4" => :mavericks
    sha256 "9c3ac1e5f9b8275be6ce9c9d47471dca3b08f02e1b269b68e77a5b5bc31d9477" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.mkpath
    man1.mkpath
    system "make", "install"
  end

  test do
    msg = "test homebrew"
    encoded = pipe_output("#{bin}/qprint -e", msg)
    assert_equal msg, pipe_output("#{bin}/qprint -d", encoded)
  end
end
