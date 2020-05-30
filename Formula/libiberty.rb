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
# Formula for libiberty, based on
# https://github.com/Homebrew/homebrew-core/blob/master/Formula/binutils.rb
#
# For reasons that make best sense to them, the Homebrew maintainers have
# decided not to ship a libiberty.a library binary or libiberty/*.h include
# files with their binutils package.  This contrasts with the approach
# chosen independently by multiple packagers in the Linux world, all of
# whom package those files in their binutils-dev or binutils-devel package.
# It also means that Homebrew users have no convenient means of installing
# libiberty to enable building of software that depends on it, usually via
# libbfd.  NovaProva is one such software, so to build NovaProva on MacOS
# we need to provide our own libiberty.
#
class Libiberty < Formula
  desc "GNU libiberty library for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.34.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.34.tar.xz"
  sha256 "f00b0e8803dc9bab1e2165bd568528135be734df3fabf8d0161828cd56028952"

  keg_only :shadowed_by_macos, "Apple's CLT provides the same tools"

  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-deterministic-archives",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}",
                          "--disable-werror",
                          "--enable-interwork",
                          "--enable-multilib",
                          "--enable-64-bit-bfd",
                          "--enable-targets=all",
                          "--enable-install-libiberty"
    system "make", "all-libiberty"
    system "make", "-C", "libiberty", "MULTIOSDIR=", "install"
  end

  test do
    system "true"
  end
end
