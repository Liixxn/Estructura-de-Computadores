;
; ADC_Software.asm
;
; Created: 28/04/2021 13:42:14
; Author : Lian Salmerón López
;


   ldi r16, 0xff
   out ddrb, r16
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
 

   CPI R16, 0b10000000
   BRPL encender
   ;Parte Then
   LDI R20, 0X00
   OUT PORTB, R20
   RJMP seguir

encender:
   LDI R20, 0XFF
   OUT PORTB, R20
;Parte Else
seguir:

rjmp loopGeneral





config_ADC:
     push r16
	 ldi r16, (1<<ADEN)
	 ori r16, (0<<ADATE)
	 ori r16, (1<<ADPS2)|(1<<ADPS1)|(1<<ADPS0)
	 STS ADCSRA, R16
	 LDI R16, (0<<ADTS2)|(0<<ADTS1)|(0<<ADTS0)
	 STS ADCSRB, R16
	 LDI R16, (1<<MUX0)
	 ORI R16, (0<<REFS1)|(1<<REFS0)
	 ORI R16, (1<<ADLAR)
	 STS ADMUX, R16
	 LDI R16, (1<<ADC1D)
	 STS DIDR0, R16
	 LDI R16, (0<<PRADC)
	 STS PRR, R16
	 pop r16
	 ret

