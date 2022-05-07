;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2022 Mathieu Othacehe <othacehe@gnu.org>
;;;
;;; This file is part of GNU Guix.
;;;
;;; GNU Guix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; GNU Guix is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Guix.  If not, see <http://www.gnu.org/licenses/>.

(define-module (gnu platforms intel)
  #:use-module (gnu platform)
  #:use-module (gnu packages linux)
  #:use-module (guix records)
  #:export (intel32-linux
            intel64-linux
            intel32-mingw
            intel64-mingw))

(define intel32-linux
  (platform
   (target "i686-linux-gnu")
   (system "i686-linux")
   (linux-architecture "i386")
   (glibc-dynamic-linker "/lib/ld-linux.so.2")))

(define intel64-linux
  (platform
   (target "x86_64-linux-gnu")
   (system "x86_64-linux")
   (linux-architecture "x86_64")
   (glibc-dynamic-linker "/lib/ld-linux-x86-64.so.2")))

(define intel32-mingw
  (platform
   (target "i686-w64-mingw32")
   (system #f)
   (glibc-dynamic-linker #f)))

(define intel64-mingw
  (platform
   (target "x86_64-w64-mingw32")
   (system #f)
   (glibc-dynamic-linker #f)))
