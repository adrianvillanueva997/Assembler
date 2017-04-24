;
; AssemblerApplication5.asm
;
; Created: 2/06/2016 13:15:07
; Author : adrian
;


; Replace with your application code
.include "m2560def.inc"
.org 0x0000
    RJMP setup
.org 0x0072
setup: 
	LDI R16, HIGH(RAMEND) ;point the stack pointer to RAMEND
	OUT SPH, R16
	LDI R16, LOW(RAMEND)
	OUT SPL, R16
	LDI R16, 0xFF ;all ones
	STS DDRK, R16 ;STS DDRK, R16 ;configure all port’s pins as outputs
	LDI R16, 0x01 ;initial position of the running light
loop: 
	RCALL wait1sec ;this routine is a 1 second delay
	RCALL generate_next_move ;generates the next position of the running light in R16
	STS PORTK, R16 ; STS PORTK, R16 ;outputs the new position for the running light
	RJMP loop

;T=0 es izq, T=1 es derecha
generate_next_move:
		BRTS derecha
		izda: LSL R16 
		     CPI R16,0b10000000   
			 brne final
			 SET  ;T=1
			rjmp final


		derecha: LSR R16
		         cpi r16,0b00000001
				 brne final
				 CLT   ;T=0
	final:RET

wait1sec:
	LDI R22, 60; CARGA EL VALOR 60 EN EL REGISTRO R22
	repeat3:
			DEC R22 ; DECREMENTA EL CONTENIDO DE R22 EN UNO
			LDI R21,0xFF ; CARGA EL VALOR 255 EN EL REGISTRO R21
	repeat2:
			DEC R21 ; DECREMENTA EL CONTENIDO DE R21 EN UNO
			LDI R20,0xff ; CARGA EL VALOR 255 EN EL REGISTRO R20
	repeat1:
			DEC R20 ; DECREMENTA EL CONTENIDO DE R20 EN UNO
			CPI R20,0 ;	COMPARA EL CONTENIDO DE R20 CON 0
			BRNE repeat1 ; REPITE EL BUCLE REPEAT1 HASTA QUE R20 CONTIENE EL VALOR 0;

			CPI R21,0 ;	COMPARA EL CONTENIDO DE R21 CON 0
			BRNE repeat2 ; REPITE EL BUCLE REPEAT2 HASTA QUE R21 CONTIENE EL VALOR 0;

			CPI R22,0;	COMPARA EL CONTENIDO DE R22 CON 0
			BRNE repeat3 ; REPITE EL BUCLE REPEAT3 HASTA QUE R22 CONTIENE EL VALOR 0;
			RET ; QUITA LA ULTIMA DIRECCION DE MEMORIA DEL STACK


.exit