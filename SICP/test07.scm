#!/usr/bin/env guile
!#

(define (count-change amount)
  (cc amount 5))

(define (cc amount kinds-of-coins)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (= kinds-of-coins 0)) 0)
        (else (+ (cc amount
                     (- kinds-of-coins 1))
                 (cc (- amount
                        (first-denomination kinds-of-coins))
                     kinds-of-coins)))))

(define (first-denomination kinds-of-coins)
  (cond ((= kinds-of-coins 1) 1)
        ((= kinds-of-coins 2) 5) 
        ((= kinds-of-coins 3) 10)
        ((= kinds-of-coins 4) 25)    
        ((= kinds-of-coins 5) 50)))

(display (count-change 1))
(newline)

(display (count-change 2))
(newline)

(display (count-change 3))
(newline)

(display (count-change 4))
(newline)

(display (count-change 5))
(newline)

(display (count-change 6))
(newline)

(display (count-change 6))
(newline)

(display (count-change 7))
(newline)

(display (count-change 8))
(newline)

(display (count-change 9))
(newline)

(display (count-change 10))
(newline)