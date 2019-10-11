; 맵
(define contour_map)
; map의 가로 크기
(define col)
; map의 세로 크기
(define row)
; 입력 자료
(define data)
; 라인 정보
(define first_line #\.)
(define second_line #\.)
(define avg)
(define not_visited 1)
(define start_x 0)
(define start_y 0)
(define test 0)

; 맵을 reference하는 함수
(define info-ref
  (lambda (x y i) 
    (begin
      (vector-ref contour_map (+ (* y col 5) (* x 5) i)))))
(define map-ref
  (lambda (x y) 
    (begin
      (define v1 (info-ref x y 0))
      (define v2 (info-ref x y 1))
      (define v3 (info-ref x y 2))
      (define v4 (info-ref x y 3))
      (define v5 (info-ref x y 4))
      (vector v1 v2 v3 v4 v5))))

; 맵을 set하는 함수
(define map-set!
  (lambda (x y index value)
    (begin
      (vector-set! contour_map (+ (* y col 5) (* x 5) index) value))))

; 맵을 초기화하는 함수
(define map-init
  (lambda ()
    (begin
      (set! contour_map (make-vector (* row col 5) 'n))
      (do ((j 0 (+ j 1)))
	  ((= j col))
	(begin
	  (map-set! j 0 1 -1)
	  (map-set! j (- row 1) 2 -1)))
      (do ((i 0 (+ i 1)))
	  ((= i row))
	(begin
	  (map-set! 0 i 3 -1)
	  (map-set! (- col 1) i 4 -1)))
      (display contour_map))))

; 출력 함수
(define print
  (lambda (x y)
    (begin 
      (display "(")
      (display x)
      (display ",")
      (display y)
      (display ")")
      (display (map-ref x y)))))

; 맵을 보여주는 함수
(define show-map
  (lambda ()
    (begin
      (do ((i 0 (+ i 1)))
	  ((= i row))
	(do ((j 0 (+ j 1)))
	    ((= j col))
	  (display j) (display ",") (display i) (display " ")
	  (display (map-ref i j))
	  (display #\newline) )
	(display #\newline)))))

(define map-visited
  (lambda ()
    (begin
      (do ((i 0 (+ i 1)))
	  ((= i row))
	(do ((j 0 (+ j 1)))
	    ((= j col))
	  (display (info-ref j i 0)))
	(display #\newline))
      (display #\newline))))
  
; 데이타를 읽어들이는 함수
(define read-data
  (lambda ()
    (begin
      (display "Input the file name : ")
      ; 파일을 열어 정보를 읽어들인다. 리스트 data에 파일을 저장한다.
      (set! data
	(let ((p (open-input-file (symbol->string(read)))))
	  (let f ((x (read p)))
	    (if (eof-object? x)
		(begin (close-input-port p) '())
		(cons x (f (read p)))))))

      ; 첫번째 줄을 읽어들여 col과 row에 값을 저장한다.
      (set! col (list-ref data 0))
      (set! row (list-ref data 1))

      ; 맵의 초기화
      (map-init))))

; 읽어들인 데이타를 가지고 셀에 정보를 써 넣는다.
(define adjust-cell
  (lambda ()
    (do ((i 2 (+ i 4)))
	((>= i (length data)))
      
      ; 열, 행, 선의 값을 c, r, p에 저장한다.
      (define c (list-ref data (+ i 1)))
      (define r (list-ref data (+ i 2)))
      (define p (list-ref data (+ i 3)))
      (display c) (display ",") (display r) (display " ")
      
      ; 선이 vertical인지 horizontal인지 체크한다. 
      (if (equal? (list-ref data i) 'V)
	  (begin
	    ; vertical인 경우
	    (if (and (<= 0 c (- col 1))
		     (<= 0 r (- row 1)))
		(begin 
		  (map-set! c r 3 p)
		  (display (map-ref c r))
		  (display #\newline)))
	    (if (and (<= 1 c col)
		     (<= 0 r (- row 1)))
		(begin 
		  (map-set! (- c 1) r 4 p)
		  (display (map-ref (- c 1) r))
		  (display #\newline)))))
      (if (equal? (list-ref data i) 'H)
	  (begin
	    ; horizontal인 경우
	    (if (and (<= 0 c (- col 1))
		     (<= 0 r (- row 1)))
		(map-set! c r 1 p))
	    (if (and (<= 0 c (- col 1))
		     (<= 1 r row))
		(map-set! c (- r 1) 2 p)))))))


; 셀의 값을 정하는 함수
(define determine-cell
  (lambda (i j)
    (begin
      ; 0. 방문한 셀임을 기록한다.
      (map-set! i j 0 'V)
      ; 1. 그 셀의 top의 값에 따라 
      (define top (info-ref i j 1))
      (if (not (eq? top 'n))
	  ; top이 숫자이면 
	  (if (>= top 0)
	      ; top이 양수이면
	      (if (eq? first_line #\.)
		  ; first_line이 숫자가 아니면 top의 값을 가진다.
		  (set! first_line top)
		  ; first_line이 숫자이고
		  (if (eq? second_line #\.)
		      ; second_line이 숫자가 아니면 top의 값을 가진다.
		      (set! second_line top)
		      (if (eq? first_line second_line)
			  (set! first_line top)))))
	  ; top이 숫자가 아니면 
	  (if (not (eq? (info-ref i (- j 1) 0) 'V))
	      ; (i, j-1)이 방문했던 셀이 아니면
	      (determine-cell i (- j 1))))

      ; 2. 그 셀의 bottom의 값에 따라
      (define bottom (info-ref i j 2))
      (if (not (eq? bottom 'n))
	  ; bottom이 숫자이면
	  (if (>= bottom 0)
	      ; bottom이 양수이면
	      (if (eq? first_line #\.)
		  ; first_line이 숫자가 아니면 bottom의 값을 가진다.
		  (set! first_line bottom)
		  ; first_line이 숫자이고
		  (if (eq? second_line #\.)
		      ; second_line이 숫자가 아니면 bottom의 값을 가진다.
		      (set! second_line bottom)
		      (if (eq? first_line second_line)
			  (set! first_line bottom)))))
	  ; bottom이 숫자가 아니면
	  (if (not (eq? (info-ref i (+ j 1) 0) 'V))
	      ; (i, j+1)이 방문했던 셀이 아니면
	      (determine-cell i (+ j 1))))

      ; 3. 그 셀의 left의 값에 따라
      (define left (info-ref i j 3))
      (if (not (eq? left 'n))
	  ; left이 숫자이면
	  (if (>= left 0)
	      ; left이 양수이면
	      (if (eq? first_line #\.)
		  ; first_line이 숫자가 아니면 left의 값을 가진다.
		  (set! first_line left)
		  ; first_line이 숫자이고
		  (if (eq? second_line #\.)
		      ; second_line이 숫자가 아니면 left의 값을 가진다.
		      (set! second_line left)
		      (if (eq? first_line second_line)
			  (set! first_line left)))))
	  ; left이 숫자가 아니면
	  (if (not (eq? (info-ref (- i 1) j 0) 'V))
	      ; (i-1, j)이 방문했던 셀이 아니면
	      (determine-cell (- i 1) j)))

      ; 4. 그 셀의 right의 값에 따라
      (define right (info-ref i j 4))
      (if (not (eq? right 'n))
	  ; right이 숫자이면
	  (if (>= right 0)
	      ; right이 양수이면
	      (if (eq? first_line #\.)
		  ; first_line이 숫자가 아니면 right의 값을 가진다.
		  (set! first_line right)
		  ; first_line이 숫자이고
		  (if (eq? second_line #\.)
		      ; second_line이 숫자가 아니면 right의 값을 가진다.
		      (set! second_line right)
		      (if (eq? first_line second_line)
			  (set! first_line right)))))
	  ; right이 숫자가 아니면
	  (if (not (eq? (info-ref (+ i 1) j 0) 'V))
	      ; (i+1, j)이 방문했던 셀이 아니면
	      (determine-cell (+ i 1) j)))
      ; 5. 셀의 값을 지정하는 함수의 끝
      )))
		   
; 같은 영역에 값을 써준다.
(define visited-check
  (lambda ()
    (do ((i 0 (+ i 1)))
	((= i row))
      (do ((j 0 (+ j 1)))
	  ((= j col))
	(if (eq? (info-ref j i 0) 'V)
	    (map-set! j i 0 avg))))))

; 아직 방문하지 않은 셀을 고른다.
(define new-start
  (lambda ()
    (do ((i 0 (+ i 1)))
	((= i row))
      (do ((j 0 (+ j 1)))
	  ((= j col))
	(if (eq? (info-ref j i 0) 'n)
	    (begin
	      (set! not_visited (+ not_visited 1))
	      (set! start_x j)
	      (set! start_y i)))))))

; main 함수      
(define main
  (lambda ()
    (read-data)
    (adjust-cell)
    (show-map)
    (do ((test 1 ()))
	((eq? not_visited 0))
      (begin
	(determine-cell start_x start_y)
	(set! avg (/ (+ first_line second_line) 2))
	(visited-check)
	(map-visited)
	(set! not_visited 0)
	(new-start)
	(display not_visited)
	(display #\newline)
	(set! first_line #\.)
	(set! second_line #\.)))))
(main)

	

