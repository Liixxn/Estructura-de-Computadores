;
; ServoMotor_Despacio.asm
;
; Created: 24/05/2021 18:56:35
; Author : lemba
;

 out ddrb, r16

loop:
   ldi r16, 50
   ldi r17, 50
  

loopLeft:
   ldi r16, 0xFF
   out portb, r16
   push r17
   call Delayx001ms
   pop r17
   ldi r16, 0x00
   out portb, r16
   call Delay18ms
   dec r17
   brne loopLeft

   ldi r17, 250

loopRight:
   ldi r16, 0xFF
   out portb, r16
   push r17
   call Delayx001ms
   pop r17
   ldi r16, 0x00
   out portb, r16
   call Delay18ms
   dec r17
   brne loopRight 


   rjmp loop   


Delay18ms:

	ldi  r20, 2
    ldi  r21, 119
    ldi  r22, 4
L1: dec  r22
    brne L1
    dec  r21
    brne L1
    dec  r20
    brne L1
	ret


//Delay de 0.01ms

Delayx001ms:

    push YH                ;Copia del registro Y
	push YL                ;  de su parte alta y baja
	in YL, SPL             ;Copia el contenido del SP hacia el registro Y
	in YH, SPH             ;  su parte baja y alta
	push r0                ;Copia del registro r0
	push r18               ;Copia del registro r18
	push r19               ;Copia del registro r19

	ldd R0, Y+5            ;Cargamos r0 con la posición del espacio de datos Y+5


bucleFor: 

    ldi  r20, 53
L2: dec  r20
    brne L2
    nop


	dec r0           ;Decrementamos r0
	brne bucleFor    ;Vuelve al bucle For hasta que r0 sea 0

	STD Y+5, R17     ;Guardamos r17 en la posición del espacio de datos Y+5
	pop r19          ;Restauramos el contenido de r19
	pop r18          ;Restauramos el contenido de r18
	pop R0           ;Restauramos el contenido de r0
	pop YL           ;Restauramos el contenido del registro Y
	pop YH           ;  su parte baja y alta
	
	ret              ;Retorna al punto de llamada de la función en el programa principal           

	;fin del delay