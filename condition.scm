;; condition.scm -- Conditions
; arch-tag: 068260f3-0c62-450f-8d2a-f5a42e9baa57

;; Copyright (C) 2005 by Free Software Foundation, Inc.

;; Author: Andreas Rottmann <rotty@debian.org>
;; Start date: Fri May 21, 2005 03:18

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU Lesser General Public License as published by
;; the Free Software Foundation; either version 2.1 of the License, or
;; (at your option) any later version.
;;
;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU Lesser General Public License for more details.
;;
;; You should have received a copy of the GNU Lesser General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.

;;; Comentary:

;; We have nothing in here; dialects that don't have an implementation
;; of srfi-34/35 can (scmxlate-include "srfi-34/35.scm").

;;; Code:


(define-condition-type &irritants &condition
  irritants?
  (values condition-irritants))

(define-condition-type &parser-error &error
  parser-error?
  (port parser-error-port))

(define-condition-type &end-of-input &condition
  end-of-input?
  (port end-of-input-port))

;;; condition.scm ends here

