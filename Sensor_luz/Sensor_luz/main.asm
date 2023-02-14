;
; Sensor_luz.asm
;
; Created: 18/05/2021 21:00:29
; Author : Lian Salmerón López
;

   ldi r16, 255
   out ddrd, r16                        ;Se establece el puerto D como salida
   Rcall config_sensor

loopGeneral:
   
   lds r17, ADCSRA                      ;El registro ADCSRA (Analog to Digital Converter Status Register A) se carga en r17
   ori r17, (1<<ADSC)                   ;Bit para disparar una conversión individual
   sts ADCSRA, r17                      ;Se guarda en el registro

esperaADC:
   clr r17                              ;Borra el contenido del registro r17
   lds r17, ADCSRA                      
   sbrc r17, ADSC                       ;Se salta la siguiente instrucción si ACSC de r17 está borrado
   rjmp esperaADC


   lds r16, ADCH                        ;Se carga el resultado de la conversion a r16
  

;Principio del if

   cpi r16, 0b10101000                  ;Se compara r16, con 168, que es el 66% de 255
   brsh apagar                          ;Si r16 >= 168, salta a apagar            

;Parte de else
   brlo comparar2                       ;Si r16 <= 168, salta a la segunda comparación
   rjmp seguir                          ;Salta a seguir si no se cumplen ninguna de estas comparaciones


;Segundo if
comparar2:

  cpi R16, 0b01010100                   ;Se compara r16 con 84, que es el 33% de 255
  brsh encender4                        ;Si r16 >= 84, salta a encender4 --> Se encenderán 4 leds
  brlo encender8                        ;Si r16 <= 84, salta a encender8 --> Se encenderán 8 leds
  rjmp seguir                           ;Salta a seguir si no se cumplen ninguna de estas comparaciones



encender4:                              

  ldi r20, 0b00001111                   ;Se activan 4 leds
  out portd, r20                        ;Se saca por el puerto D
  rjmp seguir

encender8:  
         
  ldi r20, 0xFF                         ;Se activan todos los leds
  out portd, r20                        ;Se saca por el puerto D
  rjmp seguir


apagar:

  clr r20                               ;Borra el contenido del registro r20
  out portd, r20                        ;Se saca por el puerto D


seguir:

  rjmp loopGeneral                      ;Salta al loopGeneral



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