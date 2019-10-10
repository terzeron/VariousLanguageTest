(let ((zebra 'stripes)
      (tiger 'fierce))
  (message "One kind of animal has %s and another is %s."
	   zebra tiger))

(let ((birch 3)
      pine
      fir
      (oak 'some))
  (message "Here are %d variables with %s, %s, and %s value."
	   birch pine fir oak))


(if (> 5 4)
    (message "5 is greater than 4!"))

(defun type-of-animal (characteristic)
  "Print message in echo area depending on CHARACTERISTIC.
If the CHARACTERISTIC is the symbol 'fierce', 
then warn of a tiger."
  (if (equal characteristic 'fierce)
      (message "It's a tiger!")))
(type-of-animal 'fierce)
(type-of-animal 'zebra)