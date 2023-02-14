;
; AssemblerApplication2.asm
;
; Created: 03/03/2021 13:28:38
; Author : lemba
;

//repetir:

LDI R16, 0xFF
OUT DDRB, R16    
//LDI R16, 0x00     ; Apagar
OUT PORTB, R16
//rjmp repetir

//LDI R16, 0b00100000
//OUT portb, R16








/*
.DSEG   ;Segmento de datos
    var: .byte 1

.CSEG   ;Segmento de código
 
LDI R16, 33
STS var, R16




LDI R27, 0x01
LDI R26, 0x00
LD R2, X

*/