;
; Sensor_LDR.asm
;
; Created: 04/05/2021 13:57:57
; Author : lemba
;


   ldi r16, 0xff
   out ddrd, r16
   RCALL config_ADC

loopGeneral:
   
   LDS R17, ADCSRA
   ORI R17, (1<<ADSC)
   STS ADCSRA, R17

esperaADC:
   CLR R17
   LDS R17, ADCSRA
   SBRC R17, ADSC
   RJMP esperaADC


   LDS R16, ADCH
   
   //Si r16 es mayor que 0b10000000, se enciende

   CPI R16, 0b10101000
   BRPL apagar 
   ;Parte Then
   BRMI comparar
   rjmp seguir


comparar:

CPI R16, 0b01010100 
brpl encender4
brmi encender8
rjmp seguir


encender4:

ldi r20, 0b00001111
out portd, r20
rjmp seguir

encender8:
ldi r20, 0xFF
out portd, r20
rjmp seguir


apagar:

clr r20
out portd, r20


seguir:

rjmp loopGeneral





config_ADC:
     push r16
	 ldi r16, (1<<ADEN)                               ;Bit para habilitar el conversor A/D
	 ori r16, (0<<ADATE)                              ;Bit activa/desactiva el autodisparo del conversor con una señal externa
	 ori r16, (1<<ADPS2)|(1<<ADPS1)|(1<<ADPS0)        ;Bits que ajustan la velocidad de reloj del conversor A/D
	 STS ADCSRA, R16
	 LDI R16, (0<<ADTS2)|(0<<ADTS1)|(0<<ADTS0)        ;elegir la señal externa para realizar conversiones automáticas
	 STS ADCSRB, R16
	 LDI R16, (1<<MUX0)                               ;selecionar el canal de entrada 
	 ORI R16, (0<<REFS1)|(1<<REFS0)                   ;bits para selecionar la tensión
	 ORI R16, (1<<ADLAR)
	 STS ADMUX, R16
	 LDI R16, (1<<ADC1D)                              ;deshabilitar la funcionalidad digital
	 STS DIDR0, R16
	 LDI R16, (0<<PRADC)                              ;bit para deshabilitar el ahorro de energía
	 STS PRR, R16
	 pop r16
	 ret


