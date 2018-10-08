;; Emily Lupini - CS3210 - Spring 2018
;; ====================================
;; Divide by 5 Function: Returns a count of how
;; many of the elements in a given list are
;; divisible by 5
;; parameters:
;;  lst - list of only numbers
;; assumptions:
;;  1. No nested lists
;;  2. The list conatains only numbers

(defun div-5-count (lst)
  (cond ((null lst) 0)
        ((= 0 (mod (car lst) 5)) (+ 1 (div-5-count (cdr lst))))
        (t (div-5-count (cdr lst)))
  )
)

;; test plan:
;; category/description      		data          	 	expected result
;; -----------------------------------------------------------------
;; empty list               	 	()            		 0
;; list with one 5           		(5)            	   1
;; one element no 5's           (6)                0
;; negative divisble by 5       (-10)              1
;; list with 3 divisble by 5    (5 10 15 2 3)	     3
;; no elements divisble by 5	  (2 3 4 7 6 9)			 0
;; zero                         (0)                1

(defvar empty '())
(defvar one5 '(5))
(defvar no5 '(6))
(defvar negative '(-10))
(defvar multi-match '(5 10 15 2 3))
(defvar multi-no-match '(2 3 4 7 6 9))
(defvar zero '(0))

(and
  (equalp (div-5-count empty) 0)
  (equalp (div-5-count one5) 1)
  (equalp (div-5-count no5) 0)
  (equalp (div-5-count negative) 1)
  (equalp (div-5-count multi-match) 3)
  (equalp (div-5-count multi-no-match) 0)
  (equalp (div-5-count zero) 1)
)
