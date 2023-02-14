;
; Delay.asm
;
; Created: 17/03/2021 13:44:46
; Author : lemba
;

SER R30
OUT ddrb, R30


principal:
   SER R30
   OUT ddrb, R30


   LDI R18, 45
bucle3_E:

;============
 CLR R17

bucle2_E:
   ;----------
   CLR R16

bucle1_E:
   DEC R16
   BRNE bucle1_E
   ;----------------
   DEC R17
   BRNE bucle2_E
   ;===============
    DEC R18
   BRNE bucle3_E

   CLR R30
   OUT PORTB, R30

bucle1_A:
   DEC R16
   BRNE bucle1_A


RJMP principal