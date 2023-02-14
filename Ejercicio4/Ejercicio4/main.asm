;
; Ejercicio4.asm
;
; Created: 17/04/2021 11:54:24
; Author : lemba
;


; Replace with your application code


/**************************************
Inicialización del puerto
**************************************/
ser r16
out ddrd, r16               ;Inicializar el puerto D como salida

/*************************************
Programa principal
*************************************/

main:
ldi r16, 0b00000000


repetir :
out portd, r16

;delay
push r17
call funcionDelay10ms
pop r17

lsl r16
inc r16
cpi r16, 255

brne repetir
out portd, r16

;delay
call funcionDelay10ms

clr r16
out portd, r16

rjmp main


/*********************************
Funcion Delay 10ms
*********************************/
funcionDelay10ms:

    push YH                ;Copia del reg. Y
	push YL                ;de su parte alta y baja
	in YL, SPL             ;Iniciamos el reg.
	in YH, SPH 
	push R0 
	push r18
	push r19
	push r20

	//ldd R0, Y+6


//bucleFor:
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

	/*
	dec R0
	brne bucleFor
	*/

	//STD Y+6, R17
	pop r20
	pop r19
	pop r18
	pop R0
	pop YL
	pop YH
	
	ret 
              

	;fin del delay