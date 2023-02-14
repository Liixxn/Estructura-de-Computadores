;
; Luces_Audi2.asm
;
; Created: 06/04/2021 21:27:35
; Author : lemba
;

/*******************************************************************************
Inicialización de los puertos y las variables
*******************************************************************************/
ser r16
out ddrd, r16


/*******************************************************************************
Programa principal
*******************************************************************************/


main:
	 ldi r16, 1 
repetir:
out portd, r16


     lsl r16       ;Desplazar a la izquierda 
	 inc r16       
	 cpi r16,255     ;Cuando llegue a 255

brne repetir
out portd, r16

	 clr r16
	 out portd, r16

	 rjmp main


/********************
Función delay 10ms
*********************/

    push r18
    push r19
    push r20


	ldi  r18, 208
    ldi  r19, 202
L1: dec  r19
    brne L1
    dec  r18
    brne L1
    nop
    
    pop r20
	pop r19
	pop r18
	ret

;Fin del delay