.INCLUDE "tn11def.inc"   ;(ATTINY11 DEFINITIONS)
.DEF A = R16             ;GENERAL PURPOSE ACCUMULATOR

.def tgl_io_regA = r21;
.def tgl_io_regB = r22;

.macro tgl_io
	in tgl_io_regA, @0;input the io data in first arg
	ldi  tgl_io_regB, (1<<@1); input the 2nd arg bit to reg b
	eor tgl_io_regA, tgl_io_regB; toggle the bit in other reg
	out @0, tgl_io_regA; send it back to the io PORTx in 1st arg
.endmacro

.ORG 0x00
    RJMP ON_RESET        ;RESET VECTOR
.ORG OVF0addr
    RJMP TIM0_OVF ; Timer0 Overflow Handler

ON_RESET:
    SBI DDRB,0           ;SET PORTB0 FOR OUTPUT
    LDI A,0b00000101    ;SET PRESCALER TO /1024        
    OUT TCCR0,A         ;TIMER/COUNTER CONTROL REGISTER "B"
    LDI A,0b00000010    ;ENABLE TIMER-OVERFLOW INTERUPT
    OUT TIMSK,A
    LDI A,128            ;PRELOAD THE TIMER
    OUT TCNT0,A        
     SEI                 ;ENABLE INTERUPTS GLOBALLY
    
MAIN_LOOP:
      NOP                ;DO NOTHING
       RJMP MAIN_LOOP

TIM0_OVF:
      tgl_io   PORTB,0       ;FLIP THE 0 BIT
      LDI A,64          ;RELOAD THE TIMER
      OUT TCNT0,A
       RETI
