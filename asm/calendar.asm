; PRINT DAY OF WEEK - SUN, MON, TUE, WED, THU, FRI, SAT
	.MODEL	SMALL
	.CODE

Char    macro   char            ; print a character
	mov	dl, char
	mov	ah, 2
	int	21h
	endm

String  macro   message         ; print a string
        mov     ah, 9
        mov     dx, offset message
        int     21h
        endm

Newline macro                   ; print a newline character
        Char    13
        Char    10
        endm

Start:
	mov	ax, @data
	mov	ds, ax

        String  Msg

        mov     cx, 10
Year:
        mov     ah, 1           ; input a number
        int     21h
        cmp     al, ' '         ; if ' ' then next
        je      Testy
        mov     dl, al          ; copy al to dl
        sub     dl, 30h
        mov     dh, 0
        mov     Y1, dx          ; copy dl to Y1
        mov     ax, YY          ; copy YY to ax
        mul     cx
        add     ax, Y1          ; add Y1 to ax
        mov     YY, ax          ; calculate result
        jmp     Year

Testy:
        cmp     YY, 1900
        jl      Error
        cmp     YY, 2100
        jg      Error

Month:
        mov     ah, 1           ; input a number
        int     21h
        cmp     al, ' '         ; if ' ' then next
        je      Testm
        mov     dl, al          ; copy al to dl
        sub     dl, 30h
        mov     Mon1, dl        ; copy dl to Y1
        mov     al, Mth         ; copy Month to ax
        mul     cl
        add     al, Mon1        ; add Mon1 to ax
        mov     Mth, al         ; calculate result
        jmp     Month

Testm:
        cmp     Mth, 1
        jl      Error
        cmp     Mth, 12
        jg      Error

Day:
        mov     ah, 1           ; input a number
        int     21h
        cmp     al, 13         ; if '\n' then next
        je      Testd
        mov     dl, al          ; copy al to dl
        sub     dl, 30h
        mov     D1, dl          ; copy dl to Y1
        mov     al, D           ; copy Month to ax
        mul     cl
        add     al, D1          ; add Mon1 to ax
        mov     D, al           ; calculate result
        jmp     Day

Testd:
        cmp     D, 1
        jl      Error

        Newline

        mov     bl, Mth
        dec     bl
        mov     bh, 0
        push    bx
        add     bx, offset Nday
        mov     al, BYTE PTR [bx]
        pop     bx
        cmp     D, al
        cmp     Mth, 2
        jne     Computeleap
        cmp     D, 29
        je      Computeleap
        jg      Error

Computeleap:
        mov     ax, YY
        sub     ax, 1600
        mov     cl, 4
        div     cl
        cmp     ah, 0
        jne     Noleap1
        mov     leap, 1         ; This year is a leap year.
Noleap1:
        mov     lp4, al
        mov     al, sumlp
        add     al, lp4
        mov     sumlp, al

        mov     ax, YY
        sub     ax, 1600
        mov     cl, 100
        div     cl
        cmp     ah, 0
        jne     Yesleap1
        mov     leap, 0         ; This year is a non-leap year.
Yesleap1:
        mov     lp100, al
        mov     al, sumlp
        add     al, lp100
        mov     sumlp, al

        mov     ax, YY
        sub     ax, 1600
        mov     dx, 0
        mov     cx, 400
        div     cx
        cmp     dx, 0
        jne     Noleap2
        mov     leap, 1
Noleap2:
        mov     lp400, al
        mov     al, sumlp
        add     al, lp400               ; the sum of # of leap years
        mov     sumlp, al
        mov     cl, sumlp
        mov     ch, 0
        mov     ax, YY
        sub     ax, 1600
        add     ax, cx                  ; diff in a week
        mov     cl, 7
        div     cl
        mov     diff, ah                ; diff in a week (mod 7)
        Char    diff

Leapmon:
        Char    leap
        cmp     leap, 1                 ; leap year?
        jne     Noleapyear              ; No leap year
        cmp     Mth, 2                  ; leap year! leap month Feb?
        jle     Notcompute              ; Yet leap day.

        ; leap year, after 2/29
        inc     diff
        jmp     next

Noleapyear:
        cmp     Mth, 2                  ; Non-leap year 2/29
        jne     next
        cmp     D, 29
        je      Error

next:
Notcompute:
        mov     bl, Mth
Sumdiff:
        dec     bl
        mov     bh, 0
        push    bx
        add     bx, offset Nday
        mov     al, BYTE PTR [bx]
        mov     ah, 0
        mov     cl, 7
        div     cl
        add     diff, ah                ; diff in a week
        pop     bx
        cmp     bl, 0
        jne     Sumdiff

Output:
        mov     al, diff
        mov     ah, 0
        mov     cl, 7
        div     cl
        mov     diff, ah                ; final diff
        mov     al, diff
        mov     ah, 0
        mov     cl, 6
        mul     cl                      ; find a day of week
        mov     bx, ax
        add     bx, offset Sun
        Char    [bx]

Exit:
	mov	ah, 4ch
	int	21h

Error:
        String Emsg

        mov     YY, 0                   ; initialize variables
        mov     Y1, 0
        mov     Mth, 0
        mov     Mon1, 0
        mov     D, 0
        mov     D1, 0

        mov     ax, 0                   ; restart
	jmp	Start

	.DATA
Msg     db      'Input YYYY MM DD (year:1900-2100): ', '$'
Emsg    db      ' Error!', 13, 10, '$'
YY      dw      0
Y1      dw      0
Mth     db      0
Mon1    db      0
D       db      0
D1      db      0
Nday    db      31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
leap    db      0
lp4     db      0
lp100   db      0
lp400   db      0
sumlp   db      0
diff    db      0
Sun     db      'Sun', 13, 10, '$'
Mon     db      'Mon', 13, 10, '$'
Tue     db      'Tue', 13, 10, '$'
Wed     db      'Wed', 13, 10, '$'
Thu     db      'Thu', 13, 10, '$'
Fri     db      'Fri', 13, 10, '$'
Sat     db      'Sat', 13, 10, '$'

	.STACK
	END	Start
