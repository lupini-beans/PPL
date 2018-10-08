;; Emily Lupini - CS3210 - Spring 2018
;; ====================================
;; Check Call Function: Takes
;; 1. A list of
;; nested lists containing a valid function
;; and the number of parameters expected by
;; that function.
;; 2. A list that represents the function to be
;; checked for.
;; and checks that the function provided exists in
;; the list and has the correct number of
;; parameters
;; parameters:
;;  lst - list of lists
;;  fun - a list of the function to be searched for
;; assumptions:
;;  1. the list will be non-empty
;;  2. the list will be in the correct format
;;  3. the count will always be non-negative
;;  4. the opening and closing parentheses for
;;      the function to be found are not included
;;      in the list
;;  5. parentheses surrounding a paremeter will be
;;      part of the paremeter. i.e (cat) is a single
;;      element in the list

(defun check-call (lst fun)
  (cond ((null fun) nil)
        ((null lst) nil)
        ((equal (car (car lst)) (car fun))
          (cond ((= (car (cdr (car lst))) (length (cdr fun))) t)
                (t nil)
          )
        )
        (t (check-call (cdr lst) fun))
  )
)

;; test plan: check-call
;; category/description      	data          	 	          expected result
;; -----------------------------------------------------------------------------
;; valid functions:
;;   two functions          '((count 1)(search 2))
;; function to check:
;;   valid instruction      '(count lst)
;;                                                               t
;; function to check:
;;    valid fun,
;;    too many parameters   '(search 2 lst '(hi))
;;                                                              nil
;; valid functions:
;;    one function          '((search 2))
;; function to check:
;;   empty list             '()
;;                                                              nil
;; valid functions:
;;    three functions
;;    one takes no params   '((one 1) (two 2) (none 0))
;; function to check:
;;    valid function,
;;    no parameters         '(none)
;;                                                              t
;; function to check:
;;    invalid function      '(search 1 lst)
;;                                                              nil
;; function to check:
;;    valid function,
;;    not enough params     '(two 1)
;;                                                              nil



; valid function lists
; for check-call
(defvar two-fun '((count 1) (search 2)))
(defvar one-fun '((search lst)))
(defvar three-fun '((one 1) (two 2) (none 0)))

; functions to check
; for check-call
(defvar valid-two '(count lst))
(defvar too-many '(search 2 lst '(hi)))
(defvar no-params '(none))
(defvar invalid-three '(search 1 lst))
(defvar too-few '(two 1))
(defvar empty '())


(print(and
  ; check-call
  ;(equalp (check-call two-fun empty) nil)
  (equalp (check-call two-fun valid-two) t)
  (equalp (check-call two-fun too-many) nil)
  (equalp (check-call three-fun no-params) t)
  (equalp (check-call three-fun invalid-three) nil)
  (equalp (check-call three-fun too-few) nil)
))
