(define (caar x) (car (car x)))
(define (cadr x) (car (cdr x)))
(define (cdar x) (cdr (car x)))
(define (cddr x) (cdr (cdr x)))

;; Problem 15
;; Returns a list of two-element lists
(define (enumerate s)
  ; BEGIN PROBLEM 15
  (begin (define (enumerate-helper s index) (if (null? s) s
                                                          (cons (list index (car s))
                                                            (enumerate-helper (cdr s) (+ index 1) ))))
         (enumerate-helper s 0)
  ))
  ; END PROBLEM 15

;; Problem 16

;; Merge two lists LIST1 and LIST2 according to ORDERED? and return
;; the merged lists.
(define (merge ordered? list1 list2)
  ; BEGIN PROBLEM 16
  (cond ((null? list1) list2)
        ((null? list2) list1)
        (else (if (ordered? (car list1) (car list2))
                  (cons (car list1) (cons (car list2) (merge ordered? (cdr list1) (cdr list2))))
                  (cons (car list2) (cons (car list1) (merge ordered? (cdr list1) (cdr list2))))
                )
          )
    )
  )
  ; END PROBLEM 16

;; Optional Problem 2

;; Returns a function that checks if an expression is the special form FORM
(define (check-special form)
  (lambda (expr) (equal? form (car expr))))

(define lambda? (check-special 'lambda))
(define define? (check-special 'define))
(define quoted? (check-special 'quote))
(define let?    (check-special 'let))

;; Converts all let special forms in EXPR into equivalent forms using lambda
(define (let-to-lambda expr)
  (cond ((atom? expr)
         ; BEGIN OPTIONAL PROBLEM 2
         expr
         ; END OPTIONAL PROBLEM 2
         )
        ((quoted? expr)
         ; BEGIN OPTIONAL PROBLEM 2
         expr
         ; END OPTIONAL PROBLEM 2
         )
        ((or (lambda? expr)
             (define? expr))
         (let ((form   (car expr))
               (params (cadr expr))
               (body   (cddr expr)))
           ; BEGIN OPTIONAL PROBLEM 2
           (cons form (cons params (map let-to-lambda body)))
           ; END OPTIONAL PROBLEM 2
           ))
        ((let? expr)
         (let ((values (cadr expr))
               (body   (cddr expr)))
           ; BEGIN OPTIONAL PROBLEM 2
           (define formals (car (zip values)))
           (define args (cadr (zip values)))
           (cons (cons 'lambda (cons (let-to-lambda formals) (map let-to-lambda body))) (let-to-lambda args))

           ; END OPTIONAL PROBLEM 2
           ))
        (else
         ; BEGIN OPTIONAL PROBLEM 2
          (map let-to-lambda expr)
         ; END OPTIONAL PROBLEM 2
         )))

; Some utility functions that you may find useful to implement for let-to-lambda

(define (zip pairs)
  (if (null? pairs)
       nil
       (if (null? (cdr pairs))
           (list (list (caar pairs)) (list (cadr (car pairs))))
           (begin
             (define lzip (zip (cdr pairs)))
             (list (cons (caar pairs) (car lzip)) (cons (cadr (car pairs)) (cadr lzip)))))))
