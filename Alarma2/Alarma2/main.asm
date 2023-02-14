;
; Alarma2.asm
;
; Created: 03/07/2021 20:15:23
; Author : lemba
;

.DSEG
contador: .byte 1

.EQU Clock = 16000000
.EQU Baud = 9600 ;Constantes para calcular baundios
.EQU UBRRvalue = Clock/(Baud*16) -1

.CSEG

.ORG 0x00000 ;Esta dirección se ejecutará por cada reset
JMP main
.ORG 0x0032 ;Cuando haya una interrupción, se ejecutará lo que haya en 0x0032
JMP USART0_reception_completed
RETI
RETI

.ORG 0x0072

main:
 LDI r16, 0xFF
 OUT DDRB, r16 ;Configuramos en r16 el puerto de salida B
 RCALL init_USART0 ;Llamamos a la función USART0
 SEI ;Habilitamos las interrupciones



loop:

 SBI portB, 5
 call delay500ms ;Creamos un loop para que se encienda y apague un led
 CBI portB, 5
 call delay500ms



 RJMP loop


	

init_USART0:
 PUSH r16 ;Copia de seguridad de r16
 LDI r16, LOW(UBRRvalue)
 STS UBRR0L, r16
 LDI r16, HIGH(UBRRvalue)
 STS UBRR0H, r16 ;Interrupciones de transmisión habilitadas
 LDI r16, (1 << RXCIE0) ;Se activa la interrupción de reccepción de datos
 ORI r16, (1 << RXEN0) ;Se activa la recepción de datos
 ORI r16, (0 << TXEN0) ;Se activa el hardware para la transmisión de datos
 STS UCSR0B, r16 ;Todo lo anterior se introduce en el reistro B

 LDI r16, (1 << UCSZ01) ;Configuramos USART0 como asíncrono
 ORI r16, (1 << UCSZ00)
 ORI r16, (0 << UPM01)
 ORI r16, (0 << UPM00)


 ORI r16, (0 << USBS0)
 STS UCSR0C, r16 ;Se establece la configuración el registro r16 del puerto C
 POP r16
 RET

USART0_reception_completed:
 push r16
 in r16, SREG
 PUSH r16
 LDS r16, UDR0 ;En UDR0 se reciben los datos

 
cpi r16, '1'
brne pops

push r17
lds r17, contador
ldi r17, 0

incrementa:
  inc r17
  out portc, r17
  call Delay1s
  cpi r17, 4

  brne incrementa
  
  STS contador, r17

pops:
	POP r16
	OUT SREG, r16
	POP r16
	RETI
 


delay500ms:
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
 ret

Delay1s:
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
   ret
