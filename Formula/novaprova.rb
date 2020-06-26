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
  sha256 "f320a1440c66ce45f526114164790b41bb6eaff7a456b267f49c7f5aacdd50ed"

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
    # The Homebrew binutils package includes broken
    # binaries for ar and ranlib which produce lib.a
    # files which cannot be linked from.  As a workaround
    # we force using the working Apple-provided binaries.
    system "./configure", "--without-valgrind",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-ar=/usr/bin/ar",
                          "--with-ranlib=/usr/bin/ranlib"
    system "make", "all"
    system "make", "V=1", "check"
    system "make", "install"
  end

  test do
    system "true"
  end
end
