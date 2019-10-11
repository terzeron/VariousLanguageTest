#!/usr/bin/env guile
!#

(define (ackermann x y)
  (cond ((= y 0) 0)
        ((= x 0) (* 2 y))
        ((= y 1) 2)
        (else (ackermann (- x 1)
                         (ackermann x (- y 1))))))

(display (ackermann 1 10))
(newline)

(display (ackermann 2 4))
(newline)

(display (ackermann 3 3))
(newline)