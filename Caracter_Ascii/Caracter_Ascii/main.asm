;
; Caracter_Ascii.asm
;
; Created: 14/04/2021 13:46:02
; Author : lemba
;

.EQU Clock = 16000000    ;frecuenciss del procesador del reloj, Hz
.EQU Baud = 9600         ;puerto serie deseado
.EQU UBRRvalue = Clock/(Baud*16) -1


.ORG 0x0000
jmp main

.ORG 0x0032
jmp USART0_reception_completed
RETI
RETI


.ORG 0x0072
main:
ldi r16, 0xFF
out ddrb, r16                      ;Configuramos el puerto B como salida

rcall init_USART0
SEI


;programar el loop para que encienda y apague un led
loop:
nop
RJMP loop

/***********************************
Configuración del puerto serie
***********************************/

init_USART0:

  push r16                                  ;Hacemos una copia de seguridad del r16
  ldi r16, LOW(UBRRvalue)
  STS UBRR0L, r16
  ldi r16, HIGH(UBRRvalue)
  STS UBRR0H, r16

  ldi r16, (1 << RXCIE0)
  ori r16, (1 << RXEN0)

  ;Para el ejercicio de "al tocar una tecla sale la siguiente"  hemos cambiado el  \\ ori r16, (0 << TXEN0)  --> ori r16, (1 << TXEN0)
  ori r16, (0 << TXEN0)
  STS UCSR0B, r16

  ldi r16, (1 << UCSZ01)    ;Bits de tamaño --> En este caso 8 bits
  ori r16, (1 << UCSZ00)

  ori r16, (0 << UPM01)     ;Bits de paridad ---> En este caso no está establecido bits de paridad
  ori r16, (0 << UPM00)

  ori r16, (0 << USBS0)     ;Ponemos el bit de stop a 1
  STS UCSR0C, r16

  pop r16
  ret

/*************************************
Función de atención a la interrupción
*************************************/

USART0_reception_completed:
  push r16
  in r16, SREG
  push r16
  lds r16, UDR0
  
  ; Codigo para que al pulsar una tecla devuelva la siguiente
  ;inc r16
  ;STS UDR0, r16
  
  out portb, r16

  pop r16
  out SREG, r16          ;Restaurar SREG del la copia
  pop r16
  RETI
























