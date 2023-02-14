 ;
; Ejercicio3.asm
;
; Created: 23/03/2021 13:14:20
; Author : lemba
;

ser r16
out ddrd, r16

main:

    clr r16

repetir:
	out portd, r16
	;delay 1s
	ldi  r20, 82
    ldi  r21, 43
    ldi  r22, 0
 L1: dec  r22
    brne L1
    dec  r21
    brne L1
    dec  r20
    brne L1

	inc r16
	cpi r16, 32
	brne repetir

    rjmp main

