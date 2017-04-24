.INCLUDE "m2560def.inc" ;pin and port "human" names for ATMega2560
 .device ATmega2560
 .EQU lowercase_a = 97  ;ASCII for 'a'
 .EQU lowercase_z = 122 ;ASCII for 'z'
 .EQU fuera_rango = 123 ;ASCII for '{'
 .EQU uppercase_A = 65 ; ASCII for 'A'
 .EQU uppercase_Z = 90 ; ASCII for 'Z'
  .EQU fuera_rangoMayus = 91 ;ASCII for '['
 .EQU dollar = 36 ;ASCII for '$
 .EQU TOUPPER = 32 ;to be subtracted from the lowercase to get the uppercase
 .EQU Clock = 16000000 ;processor’s clock frequency, Hz
 .EQU Baud = 9600 ;desired serial port baud rate (bits per second)
 .EQU UBRRvalue = Clock/(Baud*16) -1 ;calculates value to be put in UBRR0H:L

 .ORG 0x00000 ;reset interrupt vector
      jmp RESET
 .ORG 0x00032 ;interrupt vectors for USART0 
      jmp USART0_reception_completed

.ORG 0x00072 ;leave room for IRQ vectors
 RESET:
    LDI R16, HIGH(RAMEND) ;init the stack. MANDATORY if using interrupts or routines
 OUT SPH, R16
 LDI R16, LOW(RAMEND)
 OUT SPL, R16
 RCALL init_USART0 ;configure USART0
 SEI ;enable interrupts globally
 main:
        ;nothing to do here, the interrupt is launched automatically
 NOP
        rjmp main

;------- initialize USART0 as 9600baud, asynchronous, 8 data bits, 1 stop bit, no parity -----
init_USART0:
 PUSH R16
 LDI R16, LOW(UBRRvalue)
 STS UBRR0L, R16   ;load the low byte
 LDI R16, HIGH(UBRRvalue)
 STS UBRR0H, R16   ;load the low byte
 ;enable receive and transmit, enable/disable USART0 interrupts (UDR empty, Tx finished, Rx finished)
 LDI R16, (1<<RXEN0)|(1<< TXEN0)|(0<<UDRIE0)|(0<< TXCIE0)|(1<< RXCIE0)
 STS UCSR0B, R16 ;set control register UCSR0B with the corresponding bits
 ;configure USART 0 as asynchronous, set frame format: 8 data bits, 1 stop bit, no parity
 LDI R16, (0<<UMSEL00) |(1<<UCSZ01)|(1<< UCSZ00) |(0<< USBS0)|(0<<UPM01)|(0<< UPM00)
 STS UCSR0C, R16 ;set control register UCSR0C with the corresponding bits
 POP R16
 RET

;----USART0_reception_completed handler --------------------------------------------------
USART0_reception_completed:
  PUSH R16 
 IN R16, SREG ;Backup SREG. MANDATORY in interrupt handler routines
 PUSH R16
 
 ;do the desired periodic task here
 LDS R16, UDR0  ;pick up the byte received
 
comprobarByte:
 CPI R16, lowercase_a
 BRLO comprobarMayuscula
CPI r16, fuera_rango
	BRLO obtenerMayuscula
	rjmp enviarDollar
comprobarMayuscula:
	CPI R16, uppercase_A
	BRlO enviarDollar
	CPI r16,fuera_rangoMayus
	BRGE enviarDollar
	RJMP enviarByte
 obtenerMayuscula:
	SUBI R16,  TOUPPER ;se resta al byte el valor 32 para obtener el codigo ASCII de la mayuscula correspondiente 
	RJMP enviarByte
RJMP enviarDollar
 


enviarDollar:
 LDI R16, dollar

enviarByte:
 
 STS UDR0, R16  ;transmits the [modified] byte

 POP R16
 OUT SREG, R16  ;Recover SREG from the previous backup
 POP R16
 RETI ;RETI is MANDATORY when returning from an interrupt handling routine

.EXIT





