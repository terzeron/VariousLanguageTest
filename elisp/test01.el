'(rose violet daisy buttercup)
'(this list has (a list inside of it))
(+ 2 2)
'(this list includes "text between quotation marks.")
'(this list 
       looks like this)
'(this list looks like this)
;(this list looks like this) ; unquoted list

(concat "abc" "def")
(substring "The quick brown fox jumped." 16 19)
;(fill-column)
(+ 2 fill-column)
(concat "The " (number-to-string (+ 2 fill-column)) " red foxes.")
(concat "The " (int-to-string (+ 2 fill-column)) " red foxes.")

(+)
(*)
(+ 3)
(* 3)
(+ 3 4 5)
(* 3 4 5)
;(+ 2 'hello) ; int + symbol

(message "This message appears in the echo area!")
(message "The name of this buffer is: %s." (buffer-name))
(message "The value of fill-column is %d." fill-column)
(message "There are %d %s in the office!" (- fill-column 14) "pink elephants")
(message "He saw %d %s" 
	 (- fill-column 34) 
	 (concat "red "
		 (substring "The quick brown foxes jumped." 16 21)
		 " leaping."))

(set 'flowers '(rose violet daisy buttercup))
flowers
'flowers ; A quote(') means "no evaluation"

(setq carnivores '(lion tiger leopard))
(set 'carnivores '(lion tiger leopard))

(setq trees '(pine fir oak maple)
      herbivores '(gazelle antelope zebra))

(setq counter 0)
(setq counter (+ counter 1))
(setq counter (+ counter 1))
counter

