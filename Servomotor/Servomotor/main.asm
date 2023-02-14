;
; Servomotor.asm
;
; Created: 19/05/2021 13:56:24
; Author : lemba
;


//ldi r16, 0xb1000000
out ddrb, r16

loop:
   ldi r18, 50

loopLeft:
   ldi r16, 0xFF
   out portb, r16
   call Delay0ms 
   ldi r16, 0x00
   out portb, r16
   call Delay18ms
   dec r18
   brne loopLeft

   
   ldi r18, 50
loopRight:
   ldi r16, 0xFF
   out portb, r16
   call Delay2ms
   ldi r16, 0x00
   out portb, r16
   call Delay18ms
   dec r18
   brne loopRight 


   rjmp loop
   


Delay0ms:
 
    ldi  r20, 11
    ldi  r21, 99
L1: dec  r21
    brne L1
    dec  r20
    brne L1
	ret


Delay18ms:
	ldi  r20, 2
    ldi  r21, 119
    ldi  r22, 4
L2: dec  r22
    brne L2
    dec  r21
    brne L2
    dec  r20
    brne L2
	ret

Delay2ms:
	ldi  r20, 52
    ldi  r21, 242
L3: dec  r21
    brne L3
    dec  r20
    brne L3
    nop
	ret