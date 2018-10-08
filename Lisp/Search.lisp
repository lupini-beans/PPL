;; Emily Lupini - CS3210 - Spring 2018
;; ====================================
;; Search Function: Returns a count of how
;; many of the given integer were in the provided
;; list
;; parameters:
;;  num - an integer that is really a number
;;  lst - list of all types
;; assumptions:
;;  1. Nested lists will not be searched
;;  2. num is a number (not checking type)
;;  3. lst is a list (also not checking type)
;;  4. count is within acceptable range

(defun my-search (num lst)
  (cond ((null lst) 0)
        ((listp (car lst)) (+ (my-search num (car lst)) (my-search num (cdr lst))))
        ((and (numberp (car lst)) (= num (car lst)))
         (+ 1 (my-search num (cdr lst))))
        (t (my-search num (cdr lst)))
  )
)

;; test plan:
;; category/description      		data          	 	expected result
;; -------------------------------------------------------------------------
;; empty list               	 	()            		 0
;; list with one 5           		(5)            	   1
;; list with all types and 5's  (5 a b (5 4 3) 5)	 3
;; nested list with 5			      ((5))			         0

(defvar empty '())
(defvar one5 '(5))
(defvar all-types '(5 a b (5 4 3) 5))
(defvar nested '((5)))

(and
  (equalp (my-search 5 empty) 0)
  (equalp (my-search 5 one5) 1)
  (equalp (my-search 5 all-types) 3)
  (equalp (my-search 5 nested) 0)
)
