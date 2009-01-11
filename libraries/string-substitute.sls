;;; string-substitute.sls --- String substitution

;; Copyright (C) 2009 Andreas Rottmann <a.rottmann@gmx.at>

;; Author: Andreas Rottmann <a.rottmann@gmx.at>

;; This program is free software, you can redistribute it and/or
;; modify it under the terms of the new-style BSD license.

;; You should have received a copy of the BSD license along with this
;; program. If not, see <http://www.debian.org/misc/bsd.license>.

;;; Commentary:

;; Provides simple template string substitution. This library can be
;; used (maybe together with a formatter combinator library) as a
;; replacement for CL-style `format' as provided by (spells format),
;; for example.

;;; Code:
#!r6rs

(library (spells string-substitute)
  (export string-substitute)
  (import (except (rnrs base) string-copy string-for-each string->list)
          (rnrs control)
          (rnrs io simple)
          (rnrs io ports)
          (xitomatl srfi receive)
          (xitomatl srfi strings)
          (xitomatl srfi char-set))

  (define string-substitute
    (case-lambda
      ((dst template vals grammar)
        (define (lose msg . irritants)
          (apply error 'string-substitute msg irritants))
        (receive (open-brace close-brace)
                 (case grammar
                   ((braces) (values #\{ #\}))
                   ((abrackets) (values #\< #\>))
                   (else
                    (lose "invalid grammar" dst template vals grammar)))
          (let loop ((i 0) (open-pos #f) (parts '()))
            (define (output str)
              (cond ((eqv? dst #f)
                     (cons str parts))
                    ((eqv? dst #t) (display str) parts)
                    (else (display str dst) parts)))
            (define (handle-close-brace/escaped pos)
              (unless (doubled-char? template pos)
                (lose "unexpected close brace" template pos))
              (loop (+ pos 2) open-pos (output (substring/shared template i (+ pos 1)))))
            (define (handle-open-brace pos)
              (cond ((doubled-char? template pos)
                     (loop (+ pos 2) #f (output (substring/shared template i (+ pos 1)))))
                    (else
                     (loop (+ pos 1) pos (output (substring/shared template i pos))))))
            (if (not i)
                (if (eqv? dst #f)
                    (string-concatenate-reverse parts))
                (cond (open-pos
                       (let ((close-pos (string-index template close-brace i)))
                         (unless close-pos
                           (lose "unmatched opening brace" template open-pos))
                         (cond ((doubled-char? template close-pos)
                                (loop (+ close-pos 2) open-pos parts))
                               (else
                                (loop (+ close-pos 1)
                                      #f
                                      (output (subst-one template open-pos close-pos vals lose)))))))
                      (else
                       (let ((open-pos (string-index template open-brace i))
                             (close-pos (string-index template close-brace i)))
                         (cond
                          ((not (or open-pos close-pos))
                           (loop #f #f (output (substring/shared template i))))
                          ((not open-pos)
                           (handle-close-brace/escaped close-pos))
                          ((not close-pos)
                           (handle-open-brace open-pos))
                          ((< open-pos close-pos)
                           (handle-open-brace open-pos))
                          (else
                           (handle-close-brace/escaped close-pos))))))))))
      ((template vals grammar)
       (string-substitute #f template vals grammar))
      ((template vals)
       (string-substitute #f template vals 'braces))))

  (define (doubled-char? s i)
    (let ((c (string-ref s i)))
      (and (< (+ i 1) (string-length s))
           (char=? c (string-ref s (+ i 1))))))

  (define (subst-one template open-pos close-pos vals lose)
    (let* ((placeholder (substring/shared template (+ open-pos 1) close-pos))
           (i (string->number placeholder))
           (val (cond ((vector? vals)
                       (vector-ref vals i))
                      ((list? vals)
                       (list-ref vals i))
                      (else
                       (lose "Invalid type for replacements" vals)))))
      (cond ((string? val) val)
            ((number? val) (number->string val))
            ((char? val)   (string val))
            (else
             (call-with-string-output-port
               (lambda (port)
                 (display val port)))))))

  )
