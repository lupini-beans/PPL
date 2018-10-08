;; Emily Lupini - CS3210 - Spring 2018
;; ====================================
;; Recency Sort Function: Takes a word and
;; a list  of words. If the word is not in
;; the list it will add it to the front,
;; otherwise it will move the word to the
;; front of the list
;; parameters:
;;  first-word - word to put in the front of the list
;;  lst - list of words
;; assumptions:
;;  1. the list will only contain words
;;  2. There will be no duplicate words

;; this my-search only accounts for all the same data type
(defun my-search (first-word lst)
  (cond ((null lst) 0)
        ((equal first-word (car lst))
         (+ 1 (my-search first-word (cdr lst))))
        (t (my-search first-word (cdr lst)))
  )
)

(defun remove-word (remove lst)
  (cond ((null lst) '())
        ((equal (car lst) remove) (remove-word remove (cdr lst)))
        (t (cons (car lst) (remove-word remove (cdr lst))))
  )
)

; we can assume my-search is 1 or 0 since it was specified there are no duplicates
(defun make-recent (front-word lst)
  (cond ((= (my-search front-word lst) 1)
          (cons front-word (remove-word front-word lst)))
        (t (cons front-word lst))
  )
)

;; test plan: make-recent
;; category/description      		data          	 	expected result
;; -----------------------------------------------------------------
;; empty list              cat ()                 (cat)
;; list with first first   first (first second)   (first second)
;; list with first third   first (second third first) (first second third)

;; test plan: remove-word
;; category/description      		data          	 	expected result
;; -----------------------------------------------------------------
;; empty list               cat ()                     ()
;; rmv the first element    first (first second)       (second)
;; rmv the third element    first (second third first) (second third)

;; test plan: my-search
;; category/description      		data          	 	expected result
;; -----------------------------------------------------------------
;; empty list              cat ()                 0
;; search for one element  hlp (hlp)              1
;; not one element         nope (yup)             0
;; list with multiple      cat (cat dog cat)      2


(defvar empty '())
(defvar one-elem '(hlp))
(defvar nope-element '(yup))
(defvar multi-elem '(cat dog cat))
(defvar first-first '(first second))
(defvar first-third '(second third first))

(print(and
  ; make-recent
  (equalp (make-recent 'cat empty) '(cat))
  (equalp (make-recent 'first first-first) '(first second))
  (equalp (make-recent 'first first-third) '(first second third))
  ;remove-word
  (equalp (remove-word 'cat empty) nil)
  (equalp (remove-word 'first first-first) '(second))
  (equalp (remove-word 'first first-third) '(second third))
  ; my-search
  (equalp (my-search 'cat empty) 0)
  (equalp (my-search 'hlp one-elem) 1)
  (equalp (my-search 'nope nope-element) 0)
  (equalp (my-search 'cat multi-elem) 2)
))
