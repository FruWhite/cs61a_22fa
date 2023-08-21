(define (over-or-under num1 num2)
  (cond ((< num1 num2) -1)
        ((= num1 num2) 0)
        (else 1)
  )
  )

(define (make-adder num)
  ;implementation using lambda
  ;(lambda (inc) (+ num inc))
  
  ;implementation using define
  (define (adder inc)
    (+ num inc))
  adder
)

(define (composed f g)
  (lambda (x) (f (g x))))

(define lst
  (cons (cons 1 nil) (cons 2 (cons (list 3 4) (cons 5 nil))))
)

(define (duplicate lst)
  (if (null? lst)
    nil
    (cons (car lst) (cons (car lst) (duplicate (cdr lst))))
  )
)
