;
; Ejercicio_intermitente.asm
;
; Created: 15/04/2021 19:07:36
; Author : Lian Zi Salmerón López
;


/**************************************
Inicialización del puerto
**************************************/
ser r16
out ddrd, r16               ;Inicializar el puerto D como salida

/*************************************
Programa principal
*************************************/

main:
ldi r17, 100            ;Cargamos en el registro, 100, que son las veces que repetiremos el bucle

repetir:
ldi r16, 0xFF           ;Activamos todos los leds
out portd, r16          ;Lo sacamos r16 por el puerto D

;Delay
push r17                ;Copia del registro del r17
call funcionDelayx10ms   ;Llamamos a la función
pop r17                 ;Restauramos el contenido de r17


clr r16                 ;Ponemos r16 a 0
out portd, r16          ;Lo sacamos r16 por el puerto D
;Delay
push r17                ;Copia del registro del r17
call funcionDelayx10ms   ;Llamamos a la función
pop r17                 ;Restauramos el contenido de r17

dec r17                 ;Decrementamos r17 en 1, de esta manera se repetirá una vez menos
cpi r17, 0              ;Comparamos si llegó a 0
brne repetir            ;Vuelve a repetir, hasta que se cumpla la comparación anterior

rjmp main               ;Vuelve al main


/*********************************
Funcion Delay 10ms
*********************************/
funcionDelayx10ms:

    push YH                ;Copia del registro Y
	push YL                ;  de su parte alta y baja
	in YL, SPL             ;Copia el contenido del SP hacia el registro Y
	in YH, SPH             ;  su parte baja y alta
	push r0                ;Copia del registro r0
	push r18               ;Copia del registro r18
	push r19               ;Copia del registro r19

	ldd R0, Y+5            ;Cargamos r0 con la posición del espacio de datos Y+5

;Delayx10ms
bucleFor:
    ldi  r18, 208
    ldi  r19, 202
L1: dec  r19
    brne L1
    dec  r18
    brne L1
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