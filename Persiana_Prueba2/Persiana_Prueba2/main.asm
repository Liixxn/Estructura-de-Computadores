;
; Persiana_Prueba2.asm
;
; Created: 26/05/2021 12:47:55
; Author : lemba
;

;
; Persiana_Hyperterminal.asm
;
; Created: 25/05/2021 17:40:32
; Author : lemba
;

.DSEG
   var1: .byte 1

.EQU Clock = 16000000    ;frecuencia del procesador del reloj, Hz
.EQU Baud = 9600         ;velocidad deseado bps
.EQU UBRRvalue = Clock/(Baud*16) -1



.CSEG
.ORG 0x0000
   jmp main

.ORG 0x0032                        ;Recepción de datos completa para USART0
   jmp USART0_reception_completed     ;Salta al manejo de interrupción cuando esto ocurra
   RETI
   RETI


.ORG 0x0072

main:
   ldi r16, 0xFF
   out ddrb, r16
   ldi r18, 15
   sts var1, r18
   rcall config_USART0                  ;Llamada a la rutina de configuración 
   SEI

loop:

   ldi r16, 50
   ldi r17, 50
   lds r18, var1

   brne seguir


opcionA:
   


opcionC:



 seguir:

    rjmp loop


/**************************************
DELAYS
***************************************/

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

	ldd r0, Y+5            ;Cargamos r0 con la posición del espacio de datos Y+5


bucleFor: 

    ldi  r20, 3
    ldi  r21, 19
L2: dec  r21
    brne L2
    dec  r20
    brne L2


	dec r0           ;Decrementamos r0
	brne bucleFor    ;Vuelve al bucle For hasta que r0 sea 0

	STD Y+5, r17     ;Guardamos r17 en la posición del espacio de datos Y+5
	pop r19          ;Restauramos el contenido de r19
	pop r18          ;Restauramos el contenido de r18
	pop r0           ;Restauramos el contenido de r0
	pop YL           ;Restauramos el contenido del registro Y
	pop YH           ;  su parte baja y alta
	
	ret              ;Retorna al punto de llamada de la función en el programa principal           

	;fin del delay




//Configuración del puerto serie

config_USART0:

  push r16                                  ;Hacemos una copia de seguridad del r16
  ldi r16, LOW(UBRRvalue)
  STS UBRR0L, r16
  ldi r16, HIGH(UBRRvalue)

  STS UBRR0H, r16                           ;Se habilitan interrupciones de transmisión y envío en USART0
  ldi r16, (1 << RXCIE0)                    ;Se activa el bit RXCIE0 (7) --> Activamos la interrupción de recepción de datos
  ori r16, (1 << RXEN0)                     ;Se activa el bit RXEN0  (4) --> Activamos la recepción de datos 

  ori r16, (0 << TXEN0)                     ;Se activa el bit RXEN0  (3) --> Activamos el hardware para transmitir datos
  STS UCSR0B, r16                           ;Se guardo en el registro B
   

  //Configuración de USART0
 
  ldi r16, (1 << UCSZ01)                    ;Número de bits de datos (8 bits)
  ori r16, (1 << UCSZ00)      
 
  ori r16, (1 << UPM01)                     ;Bits de Paridad 
  ori r16, (0 << UPM00)

  ori r16, (0 << USBS0)                     ;1 bit de stop
  STS UCSR0C, r16                           ;Se establece la configuración con el registro r16 en el puerto C

  pop r16                                   ;Restaura el registro r16
  ret        



//Función de atención a la interrupción

USART0_reception_completed:

  push r16                                  ;Copia de seguridad del r16
  in r16, SREG                              ;Copia el SREG en el r16
  push r16
  lds r16, UDR0                             ;El registro UDR0 es donde se recibe el dato

  cpi r16, 'a'
  breq opcionA
  cpi r16, 'c'
  breq opcionC

  pop r16                ;Restaura el registro r16
  out SREG, r16          ;Restaurar SREG de la copia
  pop r16
  RETI




