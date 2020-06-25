#
#  Copyright 2020 Gregory Banks
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
# Formula for NovaProva.
#
class Novaprova < Formula
  desc "The new generation unit test framework for C"
  homepage "http://www.novaprova.org/"
  url "https://github.com/novaprova/novaprova/archive/1.5rc1.tar.gz"
  sha256 "6394059ea356f47233a5f14aee64e2f76f460bf3be73e9d8376b75c3fee8fe08"

  depends_on "autoconf"
  depends_on "automake"
  depends_on "binutils"
  depends_on "doxygen"
  depends_on "gettext"
  depends_on "libiberty"
  depends_on "libxml2"
  depends_on "pkg-config"
  uses_from_macos "zlib"

  def install
    ENV["HOMEBREW_OPTFLAGS"] = "-g -O0"
    ENV.deparallelize
    system "automake -ac || echo woopsie"
    system "autoreconf", "-iv"
    system "./configure", "--without-valgrind",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "AR=/usr/bin/ar", "RANLIB=/usr/bin/ranlib", "all"
    system "make", "AR=/usr/bin/ar", "RANLIB=/usr/bin/ranlib", "V=1", "check"
    system "make", "install"
  end

  test do
    system "true"
  end
end
