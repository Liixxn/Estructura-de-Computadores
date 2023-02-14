;
; Pruebas_Sensor_verano.asm
;
; Created: 04/08/2021 23:11:58
; Author : lemba
;



 ldi r16, 255
   out ddrd, r16                        ;Se establece el puerto D como salida
   Rcall config_sensor

loopGeneral:
   
   lds r17, ADCSRA                      ;El registro ADCSRA (Analog to Digital Converter Status Register A) se carga en r17
   ori r17, (1<<ADSC)                   ;Bit para disparar una conversi�n individual
   sts ADCSRA, r17                      ;Se guarda en el registro

esperaADC:
   clr r17                              ;Borra el contenido del registro r17
   lds r17, ADCSRA                      
   sbrc r17, ADSC                       ;Se salta la siguiente instrucci�n si ACSC de r17 est� borrado
   rjmp esperaADC


   lds r16, ADCH                        ;Se carga el resultado de la conversi�n al registro r16


   cpi r16, 0b00110010                  ;Se compara con 50
   brsh secuencia 
   brlo secuencia2





secuencia:
   
   sbi portd, 0
   sbi portd, 2
   sbi portd, 4
   sbi portd, 6

   rjmp seguir


secuencia2:

   sbi portd, 1
   sbi portd, 3
   sbi portd, 5
   sbi portd, 7


seguir:
   
   clr r16
   out portd, r16
   rjmp loopGeneral








config_sensor:

     push r16
	 ldi r16, (1<<ADEN)                                          ;Bit para habilitar el conversor
	 ori r16, (0<<ADATE)                                         ;Bit para activar/desactivar el autodisparo del conversor
	 ori r16, (1<<ADPS2)|(1<<ADPS1)|(1<<ADPS0)                   ;Bits para austar la velocidad del reloj
	 STS ADCSRA, R16                                             ;Se guardan en el registro 
	 LDI R16, (0<<ADTS2)|(0<<ADTS1)|(0<<ADTS0)                   ;Bits que permiten elegir la se�al externa para realizar conversiones autom�ticas
	 STS ADCSRB, R16                                             ;Se guarda en el registro
	 LDI R16, (1<<MUX0)                                          ;Bits para seleccionar el canal de entrada 
	 ORI R16, (0<<REFS1)|(1<<REFS0)                              ;Bits para elegir la tensi�n m�xima
	 ORI R16, (1<<ADLAR)                                         ;Bit para alinear el resultado de la conversi�n a la izquierda
	 STS ADMUX, R16                                              ;Se guardan en el registro
	 LDI R16, (1<<ADC1D)                                         
	 STS DIDR0, R16                                              ;Se guarda en el registro
	 LDI R16, (0<<PRADC)                                         ;Bit para deshabilitar el ahorro de energ�a
	 STS PRR, R16                                                ;Se guarda en el registro
	 pop r16
	 ret              
