; project to make a button on PB3 do stuff to an LED on PB0
; doing this on an STK500 board (V2 firmware) and attiny11L in HVSP mode
; because of the HVSP connections to PB3, you must disconnect the XT1 from
; PB3 to get input from the on-board pushbutton
.include "tn11def.inc"; include the defs for stuff in the attiny11

.def reg_named_A = r16; make a name for general purpose register 16

.org 0x00
reset:
	;let's set up stuff since we have been reset yet again
	ldi reg_named_A,(1<<PB0);load PB0 bit into stuff
	out DDRB,reg_named_A;loads the stuff into DDRB thus making PB0 output
	ldi reg_named_A,(1<<PB3);load 1 into PB3 bit
	out PORTB,reg_named_A;to enable internal pullup (needed on STK500?)
	rjmp main; jump to main
	
main:
	;the main instruction area
	sbic PINB,PB3; skip if PB3 is clear (0/low) (button press)
		;sbi PORTB,PB0; put PB0 HIGH to turn off LED
		rjmp off_led;
	;sbis PINB,PB3;
	;	cbi PORTB,PB0;
	rjmp on_led;
	;rjmp main; loop back
	

on_led:
	cbi PORTB,PB0; set low to turn on LED
	rjmp main;
	
off_led:
	sbi PORTB,PB0; put PB0 HIGH to turn off LED
	rjmp main;
