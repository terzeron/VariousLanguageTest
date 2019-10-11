#!/usr/bin/env guile
!#

(define (square x) (* x x))
(define (sum-of-squares x y) (+ (square x) (square y)))
(sum-of-squares 5 6)

(define (abs x) 
  (cond ((> x 0) x)
	((= x 0) 0)
	((< x 0) (- x))))
(display (abs 2))
(newline)

(display (abs -2))
(newline)

(display (abs 0))
(newline)

(define (abs x)
  (cond ((< x 0) (- x))
	(else x)))

(display (abs 2))
(newline)

(display (abs -2))
(newline)

(display (abs 0))
(newline)

(define (abs x)
  (if (< x 0)
      (- x)
      x))

(display (abs 2))
(newline)

(display (abs -2))
(newline)

(display (abs 0))
(newline)

