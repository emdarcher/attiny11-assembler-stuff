;--------------------------------------------------;
	; ATNT_BLINKY1.ASM                                 ;
	; AUTHOR: DANIEL J. DOREY (RETRODAN@GMAIL.COM)     ;
	;--------------------------------------------------;

	.INCLUDE "TN13DEF.INC"   ;(ATTINY13 DEFINITIONS)

	.DEF A = R16             ;GENERAL PURPOSE ACCUMULATOR
	.DEF I = R20             ;INDEX
	.DEF N = R22             ;COUNTER

	.ORG 0000
	ON_RESET:
	    SBI DDRB,0           ;SET PORTB0 FOR OUTPUT     

	;--------------;
	; MAIN ROUTINE ;
	;--------------;
	MAIN_LOOP:
	      SBI   PINB,0       ;TOGGLE THE 0 BIT
	      RCALL PAUSE        ;WAIT/PAUSE
	       RJMP MAIN_LOOP    ;GO BACK AND DO IT AGAIN

	;----------------;
	;PAUSE ROUTINES  ;
	;----------------;
	PAUSE: LDI N,0           ;DO NOTHING LOOP
	PLUPE: RCALL MPAUSE      ;CALLS ANOTHER DO NOTHING LOOP
	       DEC N             ;CHECK IF WE COME BACK TO ZERO  
	        BRNE PLUPE       ;IF NOT LOOP AGAIN
	         RET             ;RETURN FROM CALL

	MPAUSE:LDI I,0           ;START AT ZERO
	MPLUP: DEC I             ;SUBTRACT ONE
	        BRNE MPLUP       ;KEEP LOOPING UNTIL WE HIT ZERO
	         RET             ;RETURN FROM CALL
