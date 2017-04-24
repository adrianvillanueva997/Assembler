;
; AssemblerApplication4.asm
;
; Created: 26/05/2016 10:44:47
; Author : adrian
;
; Replace with your application code
.include "m2560def.inc"
.org 0x0000
    RJMP setup
.org 0x0072
setup: ldi R16, 0b10000000
       out DDRB,R16;Puerto configuracion datos


LoopTurnOn:
    LDI R16,0b10000000 ; ENVIAR BIT AL PUERTO 7
	OUT PORTB,R16 ;	COGER REGISTRO16 Y LO COPIA AL PUERTOB7
LoopDelay:
	LDI R22,60
	repeat3:
			DEC R22
			LDI R21,0xFF
	repeat2:
			DEC R21
			LDI R20,0xff
	repeat1:
			DEC R20
			CPI R20,0
			BRNE repeat1

			CPI R21,0
			BRNE repeat2

			CPI R22,0
			BRNE repeat3
LoopTurnOff:
	LDI R16,0b00000000 ; ENVIAR BIT AL PUERTO 7
	OUT PORTB,R16 ;	COGER REGISTRO16 Y LO COPIA AL PUERTOB7
LoopDelay2:
	LDI R22,60
	repeat33:
			DEC R22
			LDI R21,0xFF
	repeat22:
			DEC R21
			LDI R20,0xff
	repeat11:
			DEC R20
			CPI R20,0
			BRNE repeat11

			CPI R21,0
			BRNE repeat22

			CPI R22,0
			BRNE repeat33
rjmp LoopTurnOn
.exit
