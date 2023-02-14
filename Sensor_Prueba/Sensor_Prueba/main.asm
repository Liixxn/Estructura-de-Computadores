;
; Sensor_Prueba.asm
;
; Created: 22/05/2021 22:48:41
; Author : lemba
;


; Replace with your application code

.DSEG

var1: .byte 1
var2: .byte 1



.CSEG

ldi r16, 255
out ddrb, r16
Rcall config_sensor


//Se compara el nivel de luz

 loopGeneral:
 
   LDS R17, ADCSRA
   ORI R17, (1<<ADSC)
   STS ADCSRA, R17

esperaADC:
   CLR R17
   LDS R17, ADCSRA
   SBRC R17, ADSC
   RJMP esperaADC
   
   lds r16, ADCH
   STS var1, r16


//Luz > 66% --> Leds apagados
primera_comparacion:

.if (var1 > 168)

   breq loopGeneral               ;Si es más alto que 168 no se hace nada

.endif

.if(var1 <= 168)
   
   .if (var1 > 84)
    breq encender4

   .else
   BRLO segunda_comparacion
   .endif

.endif
rjmp loopGeneral



segunda_comparacion:

.if (var1 < 84)            ;(33% --> 84)
   breq encender8

.else

   rjmp loopGeneral
   
.endif                


encender4:

ldi r16, 0b00001111
out portb, r16

rjmp loopGeneral

//Luz < 33% --> 8 leds encendidos

encender8:

ldi r16, 0xFF
out portb, r16


rjmp loopGeneral















config_sensor:

     push r16
	 ldi r16, (1<<ADEN)                                          ;Bit para habilitar el conversor
	 ori r16, (0<<ADATE)                                         ;Bit para activar/desactivar el autodisparo del conversor
	 ori r16, (1<<ADPS2)|(1<<ADPS1)|(1<<ADPS0)                   ;Bits para austar la velocidad del reloj
	 STS ADCSRA, R16                                             ;Se guardan en el registro 
	 LDI R16, (0<<ADTS2)|(0<<ADTS1)|(0<<ADTS0)                   ;Bits que permiten elegir la señal externa para realizar conversiones automáticas
	 STS ADCSRB, R16                                             ;Se guarda en el registro
	 LDI R16, (1<<MUX0)                                          ;Bits para seleccionar el canal de entrada 
	 ORI R16, (0<<REFS1)|(1<<REFS0)                              ;Bits para elegir la tensión máxima
	 ORI R16, (1<<ADLAR)                                         ;Bit para alinear el resultado de la conversión a la izquierda
	 STS ADMUX, R16                                              ;Se guardan en el registro
	 LDI R16, (1<<ADC1D)                                         
	 STS DIDR0, R16                                              ;Se guarda en el registro
	 LDI R16, (0<<PRADC)                                         ;Bit para deshabilitar el ahorro de energía
	 STS PRR, R16                                                ;Se guarda en el registro
	 pop r16
	 ret                                                            