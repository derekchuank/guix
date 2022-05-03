;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2014 Eric Bavier <bavier@member.fsf.org>
;;; Copyright © 2015 Mark H Weaver <mhw@netris.org>
;;; Copyright © 2018 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2020 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2022 Maxim Cournoyer <maxim.cournoyer@gmail.com>
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

(define-module (gnu packages nutrition)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (guix licenses)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix build-system python)
  #:use-module (gnu packages)
  #:use-module (gnu packages check)
  #:use-module (gnu packages databases)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages image)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages time)
  #:use-module (gnu packages xml))

(define-public python-scrape-schema-recipe
  (package
    (name "python-scrape-schema-recipe")
    (version "0.2.0")
    ;; The PyPI archive lacks a VERSION file as well as the test suite.
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/micahcochran/scrape-schema-recipe")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "044c6qwhb4c710ksgiw29cd0qcp84h1m4y8yr2g4c8vdlm3kkqh5"))))
    (build-system python-build-system)
    (arguments
     (list
      #:phases
      #~(modify-phases %standard-phases
          (replace 'check
            (lambda* (#:key tests? #:allow-other-keys)
              (when tests?
                (substitute* "test_scrape.py"
                  (("DISABLE_NETWORK_TESTS = False")
                   "DISABLE_NETWORK_TESTS = True"))
                (invoke "pytest" "-vv")))))))
    (native-inputs (list python-pytest))
    (propagated-inputs
     (list python-extruct
           python-importlib-resources
           python-isodate
           python-requests))
    (home-page "https://github.com/micahcochran/scrape-schema-recipe")
    (synopsis "HTML Recipe format extractor")
    (description "This tool extracts cooking recipe from HTML structured data
in the @url{https://schema.org/Recipe} format.")
    (license asl2.0)))

(define-public gourmet
  (package
    (name "gourmet")
    (version "0.17.4")
    (source
     (origin
      (method git-fetch)
      (uri (git-reference
             (url "https://github.com/thinkle/gourmet")
             (commit version)))
      (file-name (git-file-name name version))
      (sha256
       (base32
        "09a2zk140l4babwdj8pwcgl9v7rvwff9cn7h3ppfhm3yvsgkrx07"))))
    (build-system python-build-system)
    (native-inputs
     `(("distutils-extra"   ,python2-distutils-extra)
       ("intltool"          ,intltool)
       ("python-pygtk"      ,python2-pygtk))) ;for tests
    ;; TODO: Add python-reportlab and/or python-poppler for printing/pdf
    ;; export, and python-beautifulsoup for web import plugin.
    (inputs
     `(("pygtk"             ,python2-pygtk)
       ("sqlalchemy"        ,python2-sqlalchemy)
       ("python-lxml"       ,python2-lxml)
       ("python-pillow"     ,python2-pillow)
       ("elib.intl"         ,python2-elib.intl)))
    (arguments
     `(#:python ,python-2               ;exception and print syntax
       #:tests? #f                      ;tests look bitrotted
       #:phases
       (modify-phases %standard-phases
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (invoke "python" "setup.py" "install" "--prefix"
                     (assoc-ref outputs "out")))))))
    (home-page "https://thinkle.github.io/gourmet/")
    (synopsis "Recipe organizer")
    (description
     "Gourmet Recipe Manager is a recipe organizer that allows you to collect,
search, organize, and browse your recipes.  Gourmet can also generate shopping
lists and calculate nutritional information.  It imports Mealmaster,
MasterCook and KRecipe files and exports PDFs, webpages, and other formats.")
    (license gpl2+)))
