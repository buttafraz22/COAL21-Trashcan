;
; TrashCan.asm
;
; Created: 12/23/2022 3:46:41 AM
; Author : 2021-CS-7,12,41,49,50
;

.include "m328pdef.inc"
.include "delay.inc"
.include "motors.inc"

.cseg
.def temp = R16

.org 0x0000

	 ;WHOLE CONFIGURATIONa
     cbi DDRB,PB4  ; input IR
	 sbi DDRB,PB5  ; using for buzzer output

	SBI DDRB, PB1 ; Set pin PB1 as output for OC1A (for Servo Motor)
	; Timer 1 setup PWM
	; Set OC1A and WMG11.
	LDI r16, 0b10100010
	STS TCCR1A, r16
	; Set WMG12 and WMG13 and Prescalar to 8
	LDI r16, 0b00011010
	STS TCCR1B, r16
	; clear counter
	LDI r16, 0
	STSw TCNT1H, r16, r16
	; count of 40000 for a 20ms period or 50 Hz cycle
	LDI r16, LOW(40000)
	LDI r17, HIGH(40000)
	STSw ICR1H,r17,r16

	
	;START THE WHOLE PROCESS

	loop:
	
	SBIS PINB,PB4  ;compare if value of IR sensor is 0, if 0 then jump to L1 which calls motor function
	CALL L1        ;jump to L1 label below
	rjmp loop

	L1:
	CALL motor
	ret
	
	
	motor:
		
		sbi PORTB,PB5   ; set buzzer as ON
		;0 degree
		LDI r16, LOW(900)
		LDI r17, HIGH(900)
		STSw OCR1AH,r17,r16
		delay 1000

		; 90 degree
		LDI r16, LOW(2900)
		LDI r17, HIGH(2900)
		STSw OCR1AH,r17,r16
		delay 1000

		; 180 degree
		LDI r16, LOW(4900)
		LDI r17, HIGH(4900)
		STSw OCR1AH,r17,r16
		delay 1000

		;back to 90 degrees
		LDI r16, LOW(2900)
		LDI r17, HIGH(2900)
		STSw OCR1AH,r17,r16
		delay 1000

		;back to 0 degree
		LDI r16, LOW(900)
		LDI r17, HIGH(900)
		STSw OCR1AH,r17,r16
		delay 1000
		
		CBI PORTB,PB5		;set buzzer as OFF
	ret
