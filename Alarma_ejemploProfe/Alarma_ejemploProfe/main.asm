;
; Alarma_ejemploProfe.asm
;
; Created: 07/07/2021 14:08:33
; Author : Lian
;

.DSEG
varContador: .byte 1

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

/***********************************
Programa principal
***********************************/

main:
ldi r16, 0xFF                      ;Activamos todos los leds
out ddrb, r16                      ;Configuramos el puerto B como salida


rcall init_USART0                  ;Llamada a la rutina de configuración 
SEI                                ;Establece el indicador de interrupción



;Bucle donde el Pin B5 está parpadeando constantemente 
                


Bucle:

.if (varContador == 4)

 lds r17, varContador

.else


loop: 

 SBI portb, 5                   ;Pone a set el bit 5
 call Delay500ms         
 CBI portb, 5                   ;Pone a 0 el bit 5
 call Delay500ms



 cpi r17, 0
 breq Bucle
 dec r17
 out portc, r17
 sts varContador, r17
 rjmp loop


seguir:

 pop r17

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

  ori r16, (0 << TXEN0)                     ;Bit RXEN0  (3) --> Se activa el hardware para transmitir datos
  STS UCSR0B, r16                           ;Se guardo en el registro B


  /************************
  Configuración de USART0
  ************************/
  ldi r16, (1 << UCSZ01)                    ;Número de bits de datos (8 bits)
  ori r16, (1 << UCSZ00)      
 
  ori r16, (0 << UPM01)                     ;Bits de Paridad 
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
  push r17

  cpi r16, '1'
  brne continuar
  ldi r17, 4
  sts varContador, r17


continuar:
  
  pop r16                ;Restaura el registro r16
  out SREG, r16          ;Restaurar SREG de la copia
  pop r16
  RETI

/***********************
Función delay 250ms
************************/
Delay500ms:
 push r20
 push r21
 push r22
; 500ms at 16 MHz
 ldi r20, 41 ;Delay de 500ms
 ldi r21, 150
 ldi r22, 128
L1: dec r22
 brne L1
 dec r21
 brne L1
 dec r20
 brne L1
;fin delay
 pop r22
 pop r21
 pop r20
 ret                ;Retorna al punto de llamada de la función en el programa principal
	

/***********************
Función delay 1s
************************/

Delay1s:
 
    push r20
	push r21
	push r22

    ldi  r20, 82
    ldi  r21, 43
    ldi  r22, 0
L2: dec  r22
    brne L2
    dec  r21
    brne L2
    dec  r20
    brne L2
    lpm
    nop

	pop r22
	pop r21
	pop r20
	ret