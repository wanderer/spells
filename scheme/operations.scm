;;; operations.scm --- T-like operations.

;; Copyright (C) 2009 Andreas Rottmann <a.rottmann@gmx.at>

;; Author: Andreas Rottmann <a.rottmann@gmx.at>

;; This program is free software, you can redistribute it and/or
;; modify it under the terms of the new-style BSD license.

;; You should have received a copy of the BSD license along with this
;; program. If not, see <http://www.debian.org/misc/bsd.license>.

;;; Commentary:

;; A generic dispatch system similiar to operations in T

;;; Code:

;; Auxiliary syntax
(define-syntax %method-clauses->handler
  (syntax-rules ()
    ((%method-clauses->handler ((?op ?param ...) ?body ...) ...)
     (let ((methods (list (cons ?op (lambda (?param ...) ?body ...)) ...)))
       (lambda (op)
         (cond ((assq op methods) => cdr)
               (else #f)))))))

(define-syntax object
  (syntax-rules ()
    ((object ?proc ?method-clause ...)
     (make-object ?proc (%method-clauses->handler ?method-clause ...)))))

(define (make-object proc handler)
  (annotate-procedure
   (or proc (lambda args (error 'make-object "object is not applicable"))) handler))

(define-syntax operation
  (syntax-rules ()
    ((operation ?default ?method-clause ...)
     (make-operation ?default (%method-clauses->handler ?method-clause ...)))))

(define (make-operation default handler)
  (letrec ((op (make-object
                (lambda (obj . args)
                  (cond ((and (procedure? obj) ((procedure-annotation obj) op))
                         => (lambda (method)
                              (apply method obj args)))
                        (default
                          (apply default obj args))
                        (else
                         (error 'make-operation "operation is not available" obj op))))
                handler)))
    op))

(define-syntax define-operation
  (syntax-rules ()
    ((define-operation (?name ?arg ...))
     (define ?name (operation #f)))
    ((define-operation (?name ?arg ...) ?body1 ?body ...)
     (define ?name (operation (lambda (?arg ...) ?body1 ?body ...))))))

(define (join object1 . objects)
  (make-object object1
               (lambda (op)
                 (let ((method (any (lambda (o) ((procedure-annotation o) op))
                                    (cons object1 objects))))
                   (or method
                       (error 'join "operation not available" objects op))))))
