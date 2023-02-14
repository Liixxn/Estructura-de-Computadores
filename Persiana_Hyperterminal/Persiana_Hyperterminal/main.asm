;
; Persiana_Veneciana.asm
;
; Created: 25/05/2021 17:40:32
; Author : Lian Salmerón López
;

.DSEG                                               ;Parte de datos
   var1: .byte 1                                    ;Creación de una variable

.EQU Clock = 16000000                               ;frecuencia del procesador del reloj, Hz
.EQU Baud = 9600                                    ;velocidad deseado bps
.EQU UBRRvalue = Clock/(Baud*16) -1



.CSEG                                               ;Parte código
.ORG 0x0000
   jmp main                                         ;Salta al main

.ORG 0x0032                                         ;Recepción de datos completa para USART0
   jmp USART0_reception_completed                   ;Salta al manejo de interrupción cuando esto ocurra
   RETI
   RETI


.ORG 0x0072

main:
   ldi r16, 0xFF                        ;Carga el registro r16, a 1´s
   out ddrb, r16                        ;Se establece el puerto B como salida
   rcall config_USART0                  ;Llamada a la rutina de configuración 
   SEI

loop:
   
   lds r18, var1                        ;Se carga var1, que guarda el resultado de la comparación en el USART0_reception en r18
   
   ldi r16, 0xFF                        ;Carga el registro r16, a 1´s
   out portb, r16                       ;Se saca por el puerto B
   push r18                             ;Se realiza una copia del registro r18
   call Delayx001ms                     ;Se llama a la funcion Delay de 0.01ms
   pop r18                              ;Se restaura el contenido de r18
   ldi r16, 0x00                        ;Se carga r16, a 0´s
   out portb, r16                       ;se saca por el puerto B
   call Delay18ms                       ;Se llama a la función Delay de 18ms
   
   rjmp loop                            ;Vuelve al loop
     




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
 
  ori r16, (0 << UPM01)                     ;Bits de Paridad 
  ori r16, (0 << UPM00)

  ori r16, (0 << USBS0)                     ;1 bit de stop
  STS UCSR0C, r16                           ;Se establece la configuración con el registro r16

  pop r16                                   ;Restaura el registro r16
  ret        



//Función de atención a la interrupción

USART0_reception_completed:

  push r16                                  ;Copia de seguridad del r16
  in r16, SREG                              ;Copia el SREG en el r16
  push r16
  lds r16, UDR0                             ;El registro UDR0 es donde se recibe el dato
  
  ldS r1, var1                              ;Se carga var1, en r1
  
  
  cpi r16, 'a'                              ;Se compara r16, que contiene el dato, con "A"          
  brne opcionC                              ;Si no es igual salta a opcionC
  inc r1                                    ;Si es igual r1 se incrementa
opcionC: 
  cpi r16, 'c'                              ;Se compara r16, con "C"
  brne terminar                             ;Si no es igual salta a terminar
  dec r1                                    ;Si es igual decrementa r1

terminar:
  sts var1, r1                              ;Se guarda el resultado obenido en r1, en var1
  pop r16                                   ;Restaura el registro r16
  out SREG, r16                             ;Restaurar SREG de la copia
  pop r16
  RETI


/*******************************************
Funciones Delays
********************************************/
//Delay de 18ms

Delay18ms:

    push r20                                ;Copia de los registros usados
    push r21
    push r22

	ldi  r20, 2
    ldi  r21, 119
    ldi  r22, 4
L1: dec  r22
    brne L1
    dec  r21
    brne L1
    dec  r20
    brne L1

	pop r22                                ;Se restaura el contenido de los registros usados
	pop r21
	pop r20

	ret                                    ;Retorna al punto de llamada de la función


//Delay de 0.01ms

Delayx001ms:

    push YH                                ;Copia del registro Y
	push YL                                ;  de su parte alta y baja
	in YL, SPL                             ;Copia el contenido del SP hacia el registro Y
	in YH, SPH                             ;  su parte baja y alta
	push r0                                ;Copia del registro r0
	push r20                               ;Copia del registro r20
	
	ldd r0, Y+5                            ;Cargamos r0 con la posición del espacio de datos Y+5

bucleFor:

    ldi  r20, 53
L2: dec  r20
    brne L2
    nop
	

	dec r0                               
	brne bucleFor    

	pop r20                               ;Restauramos el contenido de r20
	pop r0                                ;Restauramos el contenido de r0
	pop YL                                ;Restauramos el contenido del registro Y
	pop YH                                ;  su parte baja y alta
	
	ret                                   ;Retorna al punto de llamada de la función          

	                                      ;fin del delay