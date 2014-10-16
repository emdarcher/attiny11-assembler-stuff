;this program will do PWM on an LED connected to PB0 
;on an STK500 board.
;the PWM will be done without the usual capture/compare method b/c the 
;attiny11's one 8-bit timer doesn't have that ability, only timer overflow.
;So we are going to use the timer overflow interrupt to toggle the led and
;set the timer's counter to a value to count from, that is not 0. It will
;count from that value until overflow, toggle led again, then set a 
;new count value that is 255-(the original count value) to create the 
;period/duty cycle. 

;this will also fade it!!!

.INCLUDE "tn11def.inc"   ;(ATTINY11 DEFINITIONS)

;****DEFINING_REGISTER_NAMES****;
.DEF A = R16             ;GENERAL PURPOSE ACCUMULATOR
.def status_regA = r17;
.def transfer_regA = r18;
.def transfer_regB = r23;
.def tgl_io_regA = r21;
.def tgl_io_regB = r22;
.def pwm_val_store = r19; to store the PWM val (0-255);
.def pwm_calc_store = r20;

.def PWM_INC_VAL = r13; to store increments to PWM in a counter
.def temp_pwm = r14;

.equ PWM_dir_bit = 1; bit for PWM direction status in status_regA
.equ PWM_flag_bit = 2;

;****MACROS****;
.macro tgl_io
	in tgl_io_regA, @0; input the io data in first arg
	ldi  tgl_io_regB, (1<<@1); input the 2nd arg bit to reg b
	eor tgl_io_regA, tgl_io_regB; toggle the bit in other reg
	out @0, tgl_io_regA; send it back to the io PORTx in 1st arg
.endmacro

.macro tgl_tfr_reg
    ldi transfer_regA, (1<<@1);toggle a bit in a register using
    eor @0, transfer_regA;      a transfer register
.endmacro

.macro tfr_to_reg
    ldi transfer_regA,@1;put 2nd arg into transfer_regA
    mov @0,transfer_regA; move that into the desired register in arg 1
    clr transfer_regA; clear the transfer register after use
.endmacro

;****INIT_CODE****;
.ORG 0000
    RJMP ON_RESET   ;RESET VECTOR
.ORG OVF0addr
    RJMP TIM0_OVF   ;Timer0 Overflow Handler

ON_RESET:
    SBI DDRB,PB0        ;SET PORTB0 FOR OUTPUT by setting bit 0 in DDRB
    LDI A,0b00000011    ;SET PRESCALER TO /64      
    OUT TCCR0,A         ;load into TIMER/COUNTER CONTROL REGISTER 
    LDI A,0b00000010    ;ENABLE TIMER-OVERFLOW INTERUPT
    OUT TIMSK,A         ;load into TIMER/COUNTER interrupt mask register
     SEI                ;ENABLE INTERUPTS GLOBALLY
    
;--------------;
; MAIN ROUTINE ;
;--------------;
MAIN_LOOP:
    NOP; do nothin'
       RJMP MAIN_LOOP

;----------------------------------;
; TIMER OVER-FLOW INTERUPT ROUTINE ;
;----------------------------------;
TIM0_OVF:

    sbis PORTB,0;
        inc PWM_INC_VAL;

    tgl_io   PORTB,0       ;FLIP THE 0 BIT in PORTB to toggle PBO
      

    mov pwm_val_store, PWM_INC_VAL;copy
    sbrc status_regA, PWM_dir_bit;skip if dir flag clear
        com pwm_val_store; 1's complement (255-val)

    mov A,pwm_val_store;
    sbic PORTB,0;skip if bit 0 is 0,
        com A; 1's complement (255-value) for ON TIME
    out TCNT0,A; set counter  
    
    and PWM_INC_VAL,PWM_INC_VAL;test for 0 or minus
    brne PWM_NOT_0;branch if not zero

    ldi A,(1<<PWM_dir_bit);flag bit
    eor status_regA,A; toggle the flag

PWM_NOT_0: ; branches to here
    nop;
    RETI; return from the interrupt service routine
 

