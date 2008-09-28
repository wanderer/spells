(library (spells strings)
  (export
   string-map string-map!
   string-fold       string-unfold
   string-fold-right string-unfold-right 
   string-tabulate string-for-each string-for-each-index
   string-every string-any
   string-hash string-hash-ci
   string-compare string-compare-ci
   string=    string<    string>    string<=    string>=    string<>
   string-ci= string-ci< string-ci> string-ci<= string-ci>= string-ci<> 
   string-downcase  string-upcase  string-titlecase  
   string-downcase! string-upcase! string-titlecase! 
   string-take string-take-right
   string-drop string-drop-right
   string-pad string-pad-right
   string-trim string-trim-right string-trim-both
   string-filter string-delete
   string-index string-index-right 
   string-skip  string-skip-right
   string-count
   string-prefix-length string-prefix-length-ci
   string-suffix-length string-suffix-length-ci
   string-prefix? string-prefix-ci?
   string-suffix? string-suffix-ci?
   string-contains string-contains-ci
   string-copy! substring/shared
   string-reverse string-reverse! reverse-list->string
   string-concatenate string-concatenate/shared string-concatenate-reverse
   string-append/shared
   xsubstring string-xcopy!
   string-null?
   string-join
   string-tokenize
   string-replace
    ; R5RS extended:
   string->list string-copy string-fill!
   )
  (import (except (rnrs base) string-copy string-for-each string->list)
          (except (rnrs mutable-strings) string-fill!)
          (rnrs control)
          (rnrs syntax-case)
          (except (rnrs unicode) string-upcase string-downcase string-titlecase)
          (rnrs r5rs)
          (rnrs arithmetic bitwise)
          (spells receive)
          (spells opt-args)
          (spells char-set)
          (for (spells include) run expand))

  (define-syntax check-arg
    (lambda (stx)
      (syntax-case stx ()
        [(_ pred val caller)
         (identifier? #'val)
         #'(unless (pred val)
             (error "check-arg failed" val))])))

  (define (char-cased? c)
    (char-upper-case? (char-upcase c)))

  (include ((scheme spells) srfi-13)))