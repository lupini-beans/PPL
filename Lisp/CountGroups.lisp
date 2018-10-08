;; Emily Lupini - CS3210 - Spring 2018
;; ====================================
;; Count Clumps Function: Takes a list
;; and counts two or more identical
;; adjacent
;; parameters:
;;  lst - list of integers or characters
;; assumptions:
;;  1. No nested lists

(defun count-clumps (counter clump current-value lst)
  (cond ((null (cdr lst))
            (cond ((and (null clump) (equal current-value (car lst))) (+ 1 counter))
                  (t counter)
            )
        )
        ((equal current-value (car lst))
          (cond ((equal clump current-value) (count-clumps counter current-value (car lst) (cdr lst)))
                (t (count-clumps (+ 1 counter) current-value (car lst) (cdr lst)))
          )
        )
        (t (count-clumps counter nil (car lst) (cdr lst)))
  )
)

(defun clump-check(lst)
  (cond ((null lst) 0)
        ((null (cdr lst)) 0)
        (t (count-clumps 0 nil (car lst) (cdr lst)))
  )
)

;; test plan: clump-check
;; category/description      		data          	 	expected result
;; -----------------------------------------------------------------
;; empty list               	 	()            		 0
;; two clumps all atoms      		(hlp hlp me me)    2
;; one clump all numbers        (1 2 3 3 4)        1
;; one element                  (2)                0
;; multi-mixed elements         (1 2 cat cat 4 4)	 2

;; test plan: count-clumps
;; category/description      		     data          	 	expected result
;; -----------------------------------------------------------------
;; no prev, no count              0 nil hlp '(hlp hlp)      1
;; count 3, clump already found   3 4 5 '(2 3 4)            3


(defvar empty '())
(defvar two-clumps '(hlp hlp me me))
(defvar one-clump '(1 2 3 3 4))
(defvar one-element '(2))
(defvar multi-mix '(1 2 cat cat 4 4))

(print
(and
  ;clump-check
  (equalp (clump-check empty) 0)
  (equalp (clump-check two-clumps) 2)
  (equalp (clump-check one-clump) 1)
  (equalp (clump-check one-element) 0)
  (equalp (clump-check multi-mix) 2)
  ;count-clumps
  (equalp (count-clumps 0 nil 'hlp '(hlp hlp)) 1)
  (equalp (count-clumps 3 4 5 '(2 3 4)) 3)
)
)
