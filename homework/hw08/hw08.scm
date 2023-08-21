(define (my-filter pred s)
  (if (null? s)
    nil
    (if (pred (car s))
      (cons (car s) (my-filter pred (cdr s)))
      (my-filter pred (cdr s)))))

(define (interleave lst1 lst2)
  (cond ((null? lst2) lst1)
    ((null? lst1) lst2)
    (else (cons (car lst1) (cons (car lst2) (interleave (cdr lst1) (cdr lst2)))))   )
)

(define (accumulate joiner start n term)
  (if (= n 0)
    start
    (accumulate joiner (joiner start (term n)) (- n 1) term)) 
)

(define (no-repeats lst)
  (define (no-repeats-helper in_lst out_lst)
    (if (null? in_lst)
      out_lst
      (begin (define out_lst (append out_lst (list (car in_lst))))
       (define in_lst (filter (lambda (x) (not(= (car in_lst) x))) in_lst))
       (no-repeats-helper in_lst out_lst)
      )  
    )
  )
  (no-repeats-helper lst nil)
)  

  

