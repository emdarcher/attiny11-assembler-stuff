.INCLUDE "tn11def.inc"   ;ATTINY11 DEFINITIONS
.DEF A = r16             ;GENERAL PURPOSE ACCUMULATOR

;.ORG 0000
ON_RESET:
    sbi DDRB,0           ;SET PORTB0 FOR OUTPUT
    ldi A,0x05;0b00000101    ;SET TIMER PRESCALER TO /1024
    out TCCR0,A

MAIN_LOOP:
      sbi   PORTB,0       ;FLIP THE 0 BIT
      rcall PAUSE        ;WAIT
       rjmp MAIN_LOOPB    ;GO BACK AND DO IT AGAIN

MAIN_LOOPB:
      cbi   PORTB,0       ;FLIP THE 0 BIT
      rcall PAUSE        ;WAIT
       rjmp MAIN_LOOP    ;GO BACK AND DO IT AGAIN

PAUSE:          
PLUPE: in   A,TIFR      ;WAIT FOR TIMER
       andi A,0x02;0b00000010  ;(TOV0)
        breq PLUPE
       ldi  A,0x02;0b00000010  ;RESET FLAG
       out  TIFR,A        ;NOTE: WRITE A 1 (NOT ZERO)
        ret

