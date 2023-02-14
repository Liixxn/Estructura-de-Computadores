;
; timer.asm
;
; Created: 05/05/2021 13:38:45
; Author : lemba
;

;Configurar como salida

//PD6 es ahora una salida
SBI ddrd, ddd6
//PD5 es ahora una salida
SBI ddrd, ddd5

ldi r16, 0x00
out OCR0A, r16
//set PWM for 50% duty cycle
ldi r16, 127
out OCR0B, r16
//set PWM for 50% duty cycle

clr r16
ldi r16 (1<<COM0A1)|(1<<COM0B1)
//poner el modo no inverso
ori r16, (1<<WGM01)|(1<<WGM00)
out TCCR0A, r16

ldi r16, (0b010 << CS00)
out TCCR0B, r16


loop:
    inc r16
	out OCR0A, r16    ;PIn D6, el 6 en arduino
	call Delay250ms
	rjmp loop



/**************************
Función Delay 250ms
**************************/
Delay250ms:

    push r18
	push r19
	push r20  

	ldi  r18, 21
    ldi  r19, 75
    ldi  r20, 191
L1: dec  r20
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1
    nop

	pop r20
	pop r19
	pop r18

	ret


