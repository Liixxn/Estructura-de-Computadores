;
; Pruebas_Luces.asm
;
;Ejercicio de verano con 8 leds
;
; Created: 04/08/2021 22:26:29
; Author : lemba
;


ser r16
out ddrd, r16


main:

ldi r16, 0xFF
out portd, r16
call delay1s
clr r16
out portd, r16



sbi portd, 0
sbi portd, 2
sbi portd, 4
sbi portd, 6

call delay1s

clr r16
out portd, r16

sbi portd, 1
sbi portd, 3
sbi portd, 5
sbi portd, 7
call delay1s



rjmp main




//Delay 1s

delay1s:

    push r18
	push r19
	push r20


    ldi  r18, 82
    ldi  r19, 43
    ldi  r20, 0
L1: dec  r20
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1
    lpm
    nop

    pop r20
	pop r19
	pop r18

	ret