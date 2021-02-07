class Gwenhywfar < Formula
  desc "Utility library required by aqbanking and related software"
  homepage "https://www.aquamaniac.de/"
  url "https://www.aquamaniac.de/rdm/attachments/download/348/gwenhywfar-5.5.0.tar.gz"
  sha256 "c625621f8a6500a4a94a364a24fed74651d3a5300f8437e0c02f9072a84cf8c0"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://www.aquamaniac.de/rdm/projects/gwenhywfar/files"
    regex(/href=.*?gwenhywfar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "23cc96ccdd30897d3fe998ad6a6f8f84a3c5ca89d0b78f162fedc0a8b4d89e26"
    sha256 big_sur:       "94677112862b163f17bf3b66973f8f38ef5c7c9281edff9f35bd9ab63fc87f9b"
    sha256 catalina:      "0ecd6df52f49623e27d2272ac3f2b047df7fed883fa75dec1fc794df03192805"
    sha256 mojave:        "6b52b25cbac6e88c2db675085762c22998897731181d550ff2c46ecc8ac93533"
    sha256 high_sierra:   "71f2b5747cd620a2330e62a5e99f673e65049bb0282781f3e7e66a245f78e712"
  end

  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "openssl@1.1"
  depends_on "pkg-config" # gwenhywfar-config needs pkg-config for execution

  def install
    inreplace "gwenhywfar-config.in.in", "@PKG_CONFIG@", "pkg-config"
    system "autoreconf", "-fiv" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-guis=cocoa"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gwenhywfar/gwenhywfar.h>

      int main()
      {
        GWEN_Init();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/gwenhywfar5", "-L#{lib}", "-lgwenhywfar", "-o", "test"
    system "./test"
  end
end
