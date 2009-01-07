#!r6rs

;;@ Pathname abstraction.
(library (spells pathname)
  (export make-file
          file?
          file-name
          file-type
          file-types
          file-version

          make-pathname
          pathname?
          x->pathname
          pathname=?
          pathname<?
          pathname>?
          
          pathname-origin
          pathname-directory
          pathname-file
          pathname-with-origin
          pathname-with-directory
          pathname-with-file
          pathname-default
          merge-pathnames
          directory-pathname?
          pathname-as-directory
          pathname-container
          pathname-join
          
          directory-namestring
          file-namestring
          origin-namestring
          x->namestring

          parse-unix-file-types)
  (import (except (rnrs base) string-copy string-for-each string->list)
          (spells receive)
          (spells lists)
          (spells strings)
          (spells char-set)
          (spells record-types)
          (spells opt-args)
          (spells parameter)
          (spells operations)
          (spells pathname os-string)
          (spells include))

  (include-file ((spells scheme) pathname)))
