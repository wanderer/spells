;;; awk.sls --- AWK loop macro

;; Copyright (C) 2009 Andreas Rottmann <a.rottmann@gmx.at>

;; Author: Andreas Rottmann <a.rottmann@gmx.at>

;; This program is free software, you can redistribute it and/or
;; modify it under the terms of the new-style BSD license.

;; You should have received a copy of the BSD license along with this
;; program. If not, see <http://www.debian.org/misc/bsd.license>.

;;; Commentary:

;; An awk loop, after the design of David Albertz and Olin Shivers.

;;; Code:


#!r6rs
(library (spells awk)
  (export awk)
  (import (rnrs)
          (only (srfi :1) append-map)
          (srfi :8 receive)
          (spells tracing)
          (for (spells awk helpers) run expand))

(define-syntax awk
  (lambda (stx)
    (syntax-case stx ()
      ((_ next-record
          (record field ...)
          counter
          ((state-var init-expr) ...)
          clause ...)
       (and (identifier? #'counter)
            (identifier? #'continue))
       (let*-values (((clauses) (map parse-clause #'(clause ...)))
                     ((svars) #'(state-var ...))
                     ((clauses rx-bindings)
                      (optimize-clauses clauses)))
         (with-syntax (((after-body ...) (get-after-body clauses svars))
                       ((range-var ...) (get-range-vars clauses))
                       ((rx-binding ...) rx-bindings))
           #`(let ((reader (lambda () next-record))
                   rx-binding ...)
               (let ^loop-var ((counter 0)
                               (state-var init-expr) ...
                               (range-var #f) ...)
                 (receive (record field ...) (reader)
                   (cond ((eof-object? record)
                          after-body ...)
                         (else
                          #,@(expand-loop-body #'record
                                               #'counter
                                               #'(range-var ...)
                                               svars
                                               clauses)))))))))

      ;; Left out counter...
      ((_ next-record
          (record field ...)
          ((state-var init-expr) ...)
          clause ...)
       (identifier? #'continue)
       #'(awk next-record
              (record field ...)
              counter
              ((state-variable init-expr) ...)
              clause ...)))))

)

;; Local Variables:
;; scheme-indent-styles: (foof-loop)
;; End: