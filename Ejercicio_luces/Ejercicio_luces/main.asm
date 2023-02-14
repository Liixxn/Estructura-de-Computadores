;
; Ejercicio_luces.asm
;
; Created: 24/03/2021 12:47:59
; Author : lemba
;

 ser r16
 out ddrd, r16   ;Inicializo el puerto D como salida



 main:
     
	 clr r16    ;Variable contador For izquierda
	 ldi r17, 0b00000001   ;Valor que saco por el puerto r1	 
repetirI:
     out portd, r17
	 ;Empieza el delay 75ms

	ldi  r18, 7
    ldi  r19, 23
    ldi  r20, 107
L1_I: dec  r20
    brne L1_I
    dec  r19
    brne L1_I
    dec  r18
    brne L1_I
	nop
    ;Termina el delay

	 lsl r17       ;Desplazar a la izquierda 
	 inc r16       ;Incremento el FOR
	 cpi r16,8     ;Condición de fin del for
	 brne repetirI

	 clr r16
	 ldi r17, 0b10000000
repetirD:
     out portd, r17        ;Saco por el puerto el carrusel de desplazamientos
	 ;Empieza el delay 75ms

	ldi  r18, 7
    ldi  r19, 23
    ldi  r20, 107
L1_D: dec  r20
    brne L1_D
    dec  r19
    brne L1_D
    dec  r18
    brne L1_D
	nop
	;Termina el delay

	 lsr r17       ;Desplazar a la izquierda 
	 inc r16       ;Incremento el FOR
	 cpi r16,8     ;Condición de fin del for
	 brne repetirD

	 rjmp main