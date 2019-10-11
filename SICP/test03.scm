#!/usr/bin/env guile 
!#

(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
        (else-clause)))

(new-if (= 2 3) 0 5)
(new-if (= 1 1) 0 5)

(define (sqrt x)
  (define (square x)
    (* x x))

  (define (sqrt-iter guess x)
    (new-if (good-enough? guess x)
            guess
            (sqrt-iter (improve guess x)
                       x)))
  (define (improve guess x)
    (average guess (/ x guess)))
  
  (define (average x y)
    (/ (+ x y) 2))
  
  (define (good-enough? guess x)
    (< (abs (- (square guess) x)) 0.000000000000001))
  
  (sqrt-iter 1.0 x))

(display (sqrt 2))
(newline)

  

