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
  sha256 "c60007f63864fd3bffcf84cfd94d1237efdedaa4370a85d67f2c8b22c35e5019"

  uses_from_macos "zlib"

  def install
    system "automake", "-ac"
    system "autoreconf", "-iv"
    system "./configure", "--disable-dependency-tracking",
                          "--without-valgrind",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "all"
    system "make", "install"
  end

  test do
    system "make", "V=1", "check"
  end
end
