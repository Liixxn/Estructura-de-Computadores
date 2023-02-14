;
; Luces_Audi3.asm
;
; Created: 07/04/2021 12:47:12
; Author : lemba
;



/*******************************************************************************
Programa principal
*******************************************************************************/
.equ DEBUG = 0

ser r16
out ddrd, r16   ;Inicializar el puerto D como salida

main:
	 ldi r16, 0b10000000

	 repetir: 
	 out portd, r16    ;activa los leds
	 ;delay 50 ms
	 ldi r17, 5              
	 push r17
	 call Delayx10ms
	 pop r17
	 lsr r16                 ;desplaza una posición a la derecha
	 ori r16, 0b10000000     ;se le añade un 1 al principio de r16
	 cpi r16, 0b11111111     ;cuando llegue a 255 para 
    brne repetir


     out portd, r16
	 ;delay 1000ms

     ldi r17, 100  
	 push r17
	 call Delayx10ms
	 pop r17    

	 clr r16
	 out portd, r16

	 ;delay 500ms

	 ldi r17, 50
	 push r17
	 call Delayx10ms
	 pop r17

	 rjmp main



/********************
Función delay 10ms
*********************/
Delayx10ms:

    push YH       ;backup del reg. Y
	push YL       ;   parte alta y baja
	in YL, SPL    ;Iniciamos el reg.
	in YH, SPH    ;   a la cima de la pila
	push R0       ;backup del R0
    push r18
    push r19
	ldd R0, Y+5   ;sacamos el 1º parametro de la pila
    

.if (DEBUG == 0)
bucleForR0:
	ldi  r18, 208
    ldi  r19, 202
L1: dec  r19
    brne L1
    dec  r18
    brne L1
    nop
    
	dec r0
	brne bucleForR0

.endif

	pop r19
	pop r18
	pop r0
	pop YL
	pop YH
	ret

;Fin del delay
