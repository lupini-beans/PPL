;; Emily Lupini - CS3210 - Spring 2018
;; ====================================
;; Remove Negatives Function: Takes a list
;; of integers and returns the list with all
;; negatives removed
;; parameters:
;;  lst - list of only numbers
;; assumptions:
;;  1. No nested lists
;;  2. The list conatains only numbers

(defun remove-negatives (lst)
  (cond ((null lst) '())
        ((>= (car lst) 0) (cons (car lst) (remove-negatives (cdr lst))))
        (t (remove-negatives (cdr lst)))
  )
)

;; test plan:
;; category/description      		data          	 	expected result
;; -----------------------------------------------------------------
;; empty list               	 	()            		 ()
;; list with one element        (5)            	   (5)
;; multiple positive elements   (6 5 4)            (6 5 4)
;; one negative element         (-10)              ()
;; Mixed pos/neg list           (5 -10 15 -2 3)	   (5 15 3)
;; multiple negatives	          (-2 -3 -4)			   ()
;; zero                         (0)                (0)

(defvar empty '())
(defvar one-element '(5))
(defvar multi-pos '(6 5 4))
(defvar one-negative '(-10))
(defvar mixed-pos-neg '(5 -10 15 -2 3))
(defvar multi-neg '(-2 -3 -4))
(defvar zero '(0))

(print(and
  (equalp (remove-negatives empty) '())
  (equalp (remove-negatives one-element) '(5))
  (equalp (remove-negatives multi-pos) '(6 5 4))
  (equalp (remove-negatives one-negative) '())
  (equalp (remove-negatives mixed-pos-neg) '(5 15 3))
  (equalp (remove-negatives multi-neg) '())
  (equalp (remove-negatives zero) '(0))
))
