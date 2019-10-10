(defun multiply-by-seven (number) 
  "Multiply NUMBER by seven." 
  (* 7 number))
(multiply-by-seven 3)

; C-h f (describe-function) multiply-by-seven 
; displays "Multiply NUMBER by seven" message

(defun multiply-by-seven (number) 
  "Multiply NUMBER by seven."
  (+ number number number number number number number))
(multiply-by-seven 3)

(defun multiply-by-seven (number) 
  "Multiply NUMBER by seven."
  (interactive "p")
  (message "The result is %d" (* 7 number)))

; interaction test
; 1. evaluate this function definition by C-x C-e
; 2. C-u and a number
; 3. M-x multiply-by-seven <RET>


