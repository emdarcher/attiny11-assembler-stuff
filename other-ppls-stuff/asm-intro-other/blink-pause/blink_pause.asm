;--------------------------------------------------;
; ATNT_BLINKY1.ASM                                 ;
; AUTHOR: DANIEL J. DOREY (RETRODAN@GMAIL.COM)     ;
;--------------------------------------------------;

;#include <avr/io.h>

.INCLUDE "tn11def.inc"   ;(ATTINY11 DEFINITIONS)

;.equ DDRB= 0x17
;.equ PINB= 0x16

.def A = r16             ;GENERAL PURPOSE ACCUMULATOR
.def I = r20             ;INDEX
.def N = r22             ;COUNTER

.org 0x00;
RESET:
    SBI DDRB,0           ;SET PORTB0 FOR OUTPUT     
	rjmp main;
;--------------;
; MAIN ROUTINE ;
;--------------;
main:
      SBI   PINB,0       ;TOGGLE THE 0 BIT
      RCALL PAUSE        ;WAIT/PAUSE
       RJMP mainb   ;GO BACK AND DO IT AGAIN

mainb:
      CBI   PINB,0       ;TOGGLE THE 0 BIT
      RCALL PAUSE        ;WAIT/PAUSE
       RJMP main   ;GO BACK AND DO IT AGAIN

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
