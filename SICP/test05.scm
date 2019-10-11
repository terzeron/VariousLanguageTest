#!/usr/bin/guile
!#

(define (cbrt x)
  (define (cube x)
    (* x x x))

  (define (cbrt-iter guess x)
    (if (good-enough? guess x)
	guess
	(cbrt-iter (improve guess x)
		   x)))
  
  (define (improve guess x)
    (/ (+ (/ x (* guess guess)) (* 2 guess)) 3))
  
  (define (average x y)
    (/ (+ x y) 2))
  
  (define (good-enough? guess x)
    (< (abs (- (cube guess) x)) 0.00000000000000000000000001))
  
  (cbrt-iter 1.0 x))

(display (cbrt 2))
(newline)
