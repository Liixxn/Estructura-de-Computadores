;
; Ejercicio_Ascii_Interrupcion.asm
;
; Created: 20/04/2021 13:31:40
; Author : Lian Zi Salmerón López
;

.EQU Clock = 16000000    ;frecuencia del procesador del reloj, Hz
.EQU Baud = 9600         ;velocidad deseado bps
.EQU UBRRvalue = Clock/(Baud*16) -1

;Parte de datoes
.DSEG
var1: .byte 1

;Parte de código
.CSEG
.ORG 0x0000
jmp main

.ORG 0x0032                        ;Recepción de datos completa para USART0
jmp USART0_reception_completed     ;Salta al manejo de interrupción cuando esto ocurra
RETI
RETI


.ORG 0x0072

/***********************************
Programa principal
***********************************/

main:
ldi r16, 0xFF                      ;Activamos todos los leds
out ddrb, r16                      ;Configuramos el puerto B como salida


rcall init_USART0                  ;Llamada a la rutina de configuración 
SEI                                ;Establece el indicador de interrupción



;Bucle donde el Pin B5 está parpadeando constantemente 

loop:
 SBI portb, 5                   ;Pone a set el bit 5
 ;Delay de 250ms
 call funcionDelay250ms         
 CBI portb, 5                   ;Pone a 0 el bit 5
 call funcionDelay250ms

 //lds r17, var1
.if (var1 == 0)

 SBI portb, 0
 call funcionDelay2s
 CBI portb, 0
 call funcionDelay2s

 .endif

 rjmp loop                      ;Vuelve al bucle

/***********************************
Configuración del puerto serie
***********************************/

init_USART0:

  push r16                                  ;Hacemos una copia de seguridad del r16
  ldi r16, LOW(UBRRvalue)
  STS UBRR0L, r16
  ldi r16, HIGH(UBRRvalue)

  STS UBRR0H, r16                           ;Se habilitan interrupciones de transmisión y envío en USART0
  ldi r16, (1 << RXCIE0)                    ;Se activa el bit RXCIE0 (7) --> Activamos la interrupción de recepción de datos
  ori r16, (1 << RXEN0)                     ;Se activa el bit RXEN0  (4) --> Activamos la recepción de datos 

  ori r16, (0 << TXEN0)                     ;Se activa el bit RXEN0  (3) --> Activamos el hardware para transmitir datos
  STS UCSR0B, r16                           ;Se guardo en el registro B


  /************************
  Configuración de USART0
  ************************/
  ldi r16, (1 << UCSZ01)                    ;Número de bits de datos (8 bits)
  ori r16, (1 << UCSZ00)      
 
  ori r16, (1 << UPM01)                     ;Bits de Paridad 
  ori r16, (0 << UPM00)

  ori r16, (0 << USBS0)                     ;1 bit de stop
  STS UCSR0C, r16                           ;Se establece la configuración con el registro r16 en el puerto C

  pop r16                                   ;Restaura el registro r16
  ret                                       ;Retorno de subrutina

/*************************************
Función de atención a la interrupción
*************************************/

USART0_reception_completed:

  push r16                                  ;Copia de seguridad del r16
  in r16, SREG                              ;Copia el SREG en el r16
  push r16
  lds r16, UDR0                             ;El registro UDR0 es donde se recibe el dato
  STS var1, r16

  pop r16                ;Restaura el registro r16
  out SREG, r16          ;Restaurar SREG de la copia
  pop r16
  RETI



/***********************
Función delay 250ms
************************/
funcionDelay250ms:
    
    push r20
	push r21
	push r22

    ldi  r20, 3
    ldi  r21, 138
    ldi  r22, 86
L1: dec  r22
    brne L1
    dec  r21
    brne L1
    dec  r20
    brne L1
    rjmp PC+1

    pop r22
	pop r21
	pop r20
	ret

/***********************
Función delay 2s
************************/

funcionDelay2s:
    
	push r23
	push r24
	push r25

	ldi  r23, 21
    ldi  r24, 75
    ldi  r25, 191
L2: dec  r25
    brne L2
    dec  r24
    brne L2
    dec  r23
    brne L2
    nop

	pop r25
	pop r24
	pop r23
	ret
