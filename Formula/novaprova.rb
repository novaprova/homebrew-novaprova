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
class NovaProva < Formula
  desc "The new generation unit test framework for C"
  homepage "http://www.novaprova.org/"
  url "https://github.com/novaprova/novaprova/archive/1.5rc1.zip"
  mirror "https://github.com/novaprova/novaprova/archive/1.5rc1.zip"
  sha256 "f8ed2cac985a20c5ea9fa3627f62d262e8b0f9f1c5d1bace0ea6eef28f598e65"

  # TODO: bottles
#  bottle do
#    sha256 "1e21593a927df65e405f9d3bdc8f86fe83b1236c5c945641a2de775c99327953" => :catalina
#    sha256 "142e380448ac77bc0f7974ff9b9ddae6a90c4ef5f182cac0c2b029baa8460173" => :mojave
#    sha256 "87bda0c909a5bd2043d35b073f2268cac7aed074a89d903973e4909d68dfdf46" => :high_sierra
#  end

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
