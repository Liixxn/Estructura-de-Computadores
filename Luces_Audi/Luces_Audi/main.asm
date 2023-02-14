;
; Luces_Audi.asm
;
; Created: 04/04/2021 19:09:32
; Author : lemba
;

/*******************************************************************************
Inicialización de los puertos y las variables
*******************************************************************************/
ser r16
out ddrd, r16  ;Inicializar el puerto D como salida


/*******************************************************************************
Programa principal
*******************************************************************************/


main:
	 ldi r16, 1 
repetir:
out portd, r16  ;Activar los leds

;Delay de 50ms
call funcionDelay50ms


     lsl r16       ;Desplazar a la izquierda 
	 inc r16       
	 cpi r16,255     ;Cuando llegue a 255

brne repetir
out portd, r16
;Delay de 1s
call funcionDelay1s

	 clr r16
	 out portd, r16

;Delay 500ms
call funcionDelay500ms

	 rjmp main


/******************* 
Funcion Delay  50ms
********************/
funcionDelay50ms:

    push r18
	push r19
	push r20

    ldi  r18, 5
    ldi  r19, 15
    ldi  r20, 242
L1: dec  r20
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1

	pop r20
	pop r19
	pop r18
	ret

	;fin del delay



/*************************
Funcion Delay 1s
**************************/
funcionDelay1s:
push r18
push r19
push r20


	ldi  r18, 82
    ldi  r19, 43
    ldi  r20, 0
L2: dec  r20
    brne L2
    dec  r19
    brne L2
    dec  r18
    brne L2
    lpm
    nop

	pop r20
	pop r19
	pop r18
	ret

;fin del delay


/*****************
Funcion Delay 500ms
******************/
funcionDelay500ms:

push r18
push r19
push r20

    ldi  r18, 41
    ldi  r19, 150
    ldi  r20, 128
L3: dec  r20
    brne L3
    dec  r19
    brne L3
    dec  r18
    brne L3

	pop r20
	pop r19
	pop r18
	ret

;fin del delay
