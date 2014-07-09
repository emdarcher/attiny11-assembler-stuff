.INCLUDE "tn11def.inc"   ;(ATTINY11 DEFINITIONS)
	.DEF A = R16             ;GENERAL PURPOSE ACCUMULATOR
	.def io_stuffB = r17;
	.def io_stuff_thing = r18;
	
	.ORG 0000
	    RJMP ON_RESET        ;RESET VECTOR
	.ORG OVF0addr
	    RJMP TIM0_OVF ; Timer0 Overflow Handler

	ON_RESET:
	    SBI DDRB,0           ;SET PORTB0 FOR OUTPUT
	    LDI A,0b00000101    ;SET PRESCALER TO /1024        
	    OUT TCCR0,A         ;TIMER/COUNTER CONTROL REGISTER 
	    LDI A,0b00000010    ;ENABLE TIMER-OVERFLOW INTERUPT
	    OUT TIMSK,A
	     SEI                 ;ENABLE INTERUPTS GLOBALLY
    
	;--------------;
	; MAIN ROUTINE ;
	;--------------;
	MAIN_LOOP:
	      NOP                ;DO NOTHING
	       RJMP MAIN_LOOP

	;----------------------------------;
	; TIMER OVER-FLOW INTERUPT ROUTINE ;
	;----------------------------------;
	TIM0_OVF:
	      ;SBI   PORTB,0       ;FLIP THE 0 BIT
	      in io_stuffB, PORTB; put portb states in reg
	      ldi io_stuff_thing, (1<<PB0); load PB0 bit in another register
	      eor io_stuffB, io_stuff_thing; toggle the bit in the stored reg
	      out PORTB, io_stuffB; put the new set stuff into PORTB
	       RETI
