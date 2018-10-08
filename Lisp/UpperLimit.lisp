;; Emily Lupini - CS3210 - Spring 2018
;; ====================================
;; Upper Limit Function: Takes a value
;; a list and replaces all values
;; greater than the provided value in
;; the list
;; parameters:
;;  limit - number given as upper limit
;;  lst - list of integers or characters
;; assumptions:
;;  1. the limit will always be a number

(defun upper-limit (limit lst)
  (cond ((null lst) '())
        ((listp (car lst)) (cons (upper-limit limit (car lst)) (upper-limit limit (cdr lst))))
        ((and (numberp (car lst)) (> (car lst) limit)) (cons limit (upper-limit limit (cdr lst))))
        (t (cons (car lst) (upper-limit limit (cdr lst))))
  )
)

;; test plan:
;; category/description      		data          	 	expected result
;; -----------------------------------------------------------------
;; num with empty list          2 '()          		 ()
;; list with one element above limit  4 (5)            	 (4)
;; all elements change          3 (6 5 4)          (3 3 3)
;; no elements change           6 (2 3 4)          (2 3 4)
;; Mixed types                  9 (5 12 cat -3)	   (5 9 cat -3)
;; nested list        	        2 (4 (2 9 3) -4)   (2 (2 2 2) -4)

(defvar empty '())
(defvar one-element '(5))
(defvar all-above '(6 5 4))
(defvar all-below '(2 3 4))
(defvar mixed '(5 12 cat -3))
(defvar nested '(4 (2 9 3) -4))

(print
(and
  (equalp (upper-limit 2 empty) '())
  (equalp (upper-limit 4 one-element) '(4))
  (equalp (upper-limit 3 all-above) '(3 3 3))
  (equalp (upper-limit 6 all-below) '(2 3 4))
  (equalp (upper-limit 9 mixed) '(5 9 cat -3))
  (equalp (upper-limit 2 nested) '(2 (2 2 2) -4))
)
)
