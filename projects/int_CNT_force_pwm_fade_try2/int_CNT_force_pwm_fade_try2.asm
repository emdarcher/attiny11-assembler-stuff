;this program will attempt to do PWM on an LED connected to PB0 
;on an STK500 board.
;the PWM will be done without the usual capture/compare method b/c the 
;attiny11's one 8-bit timer doesn't have that ability, only timer overflow.
;So we are going to use the timer overflow interrupt to toggle the led and
;set the timer's counter to a value to count from, that is not 0. It will
;count from that value until overflow, toggle led again, then set a 
;new count value that is 255-(the original count value) to create the 
;period/duty cycle. 

;this will also try to fade it!!! somehow..

.INCLUDE "tn11def.inc"   ;(ATTINY11 DEFINITIONS)
.DEF A = R16             ;GENERAL PURPOSE ACCUMULATOR
.def status_regA = r17;
.def transfer_regA = r18;
.def transfer_regB = r23;
;.def tgl_regA = r19;
;.def tgl_regB = r20;
.def tgl_io_regA = r21;
.def tgl_io_regB = r22;
.def pwm_val_store = r19;
.def pwm_calc_store = r20;



.def cnt_0 = r14;
.def cnt_1 = r15;
.def PWM_INC_VAL = r13; to store increments to PWM in a counter

.equ PWM_dir_bit = 1; bit for PWM direction status in status_regA

.equ CNTB_INC = 255; number of increments in counter B

.macro tgl_io
	in tgl_io_regA, @0; input the io data in first arg
	ldi  tgl_io_regB, (1<<@1); input the 2nd arg bit to reg b
	eor tgl_io_regA, tgl_io_regB; toggle the bit in other reg
	out @0, tgl_io_regA; send it back to the io PORTx in 1st arg

.endmacro

.macro tgl_tfr_reg
    ldi transfer_regA, (1<<@1);toggle a bit in a register using
    eor @0, transfer_regA;      a transfer register
    
.endmacra

.macro tfr_to_reg
    ldi transfer_regA,@1;put 2nd arg into transfer_regA
    mov @0,transfer_regA; move that into the desired register in arg 1
    clr transfer_regA; clear the transfer register after use
.endmacro

.ORG 0000
    RJMP ON_RESET        ;RESET VECTOR
.ORG OVF0addr
    RJMP TIM0_OVF ; Timer0 Overflow Handler

ON_RESET:
    SBI DDRB,0           ;SET PORTB0 FOR OUTPUT
    cbi PORTB,PB0	;put PBO 
    LDI A,0b00000011    ;SET PRESCALER TO /256;/1024        
    OUT TCCR0,A         ;TIMER/COUNTER CONTROL REGISTER 
    LDI A,0b00000010    ;ENABLE TIMER-OVERFLOW INTERUPT
    OUT TIMSK,A
    
    RCALL CLR_CNTA; call the clear of cnt_0
    RCALL SET_CNTB; same for cnt_1
    
    ;set the pwm val once for testing
    ldi pwm_val_store, 192; put 8-bit PWM val here
    ;set bit 0 to 1 in status_regA, this is where we store current pwm state
    ;sbr status_regA, a; 1 for low cycle 
     SEI                 ;ENABLE INTERUPTS GLOBALLY
    
;--------------;
; MAIN ROUTINE ;
;--------------;
MAIN_LOOP:
      ;rcall DELAY1;
      ;rcall FADE_DELAY;
      ;  rcall PWM_INC;
      nop
       RJMP MAIN_LOOP

FADE_DELAY:
        clr r12;
DELAY:
        ;NOP
        ;NOP
        ;nop
        ;nop
        ;nop
        ;nop
        ;nop
        ;nop
        ;nop
        ;nop
        ;nop
        ;nop
        ;nop
        ;nop
        ;nop
        ;nop
        dec r12;
        BRNE DELAY;
        ret;
        
DELAY1:
    tfr_to_reg r11,16;
D1: 
    rcall FADE_DELAY;
    dec r11;
    BRNE D1;
        RET;
        

;----------------------------------;
; TIMER OVER-FLOW INTERUPT ROUTINE ;
;----------------------------------;
TIM0_OVF:
      tgl_io   PORTB,0       ;FLIP THE 0 BIT in PORTB to toggle PBO
      
      RCALL COUNT_A; count stuff
      
      ;rcall PWM_INC;
      
      ldi pwm_calc_store,0xFF; reset to 255
      clr pwm_val_store;
      ;ldi transfer_regA,0xFF
      sbrs status_regA, PWM_dir_bit;if set
        rcall put_pwm_up;
      sbrc status_regA, PWM_dir_bit;if clear
        ;OR pwm_val_store,PWM_INC_VAL;
        rcall put_pwm_down;
        
      sub pwm_calc_store,pwm_val_store; subtract from 255 to get cnt value
										;to set to get PWM ON time
        sbis PORTB,0;if bit 0 is 1,
            out TCNT0, pwm_calc_store; ;and set counter 
        sbic PORTB,0;if bit 0 is 0
            out TCNT0,pwm_val_store;;set counter  
		
        ;RCALL COUNT_A; count stuff
        
	  ;tgl_io   PORTB,0       ;FLIP THE 0 BIT in PORTB to toggle PBO
            RETI;

CLR_CNTA:
    clr cnt_0;
        ret;
        
COUNT_A:
    DEC cnt_0;
        BRNE COUNT_B; increment the count_B counter 
        RET;

SET_CNTB:
    tfr_to_reg  cnt_1,CNTB_INC;
    ;ldi transfer_regA,CNTB_INC;
    ;mov cnt_1,transfer_regA;
    ;clr transfer_regA; clear the transfer register after use
        ret;
COUNT_B:
    DEC cnt_1;
        BRNE PWM_INC; goto incrementing the PWM
    RET;
    
PWM_INC:
    ;RCALL SET_CNTB; reset counter B
    ;sbrs status_regA,PWM_dir_bit; if set
    
    ;sbrc status_regA,PWM_dir_bit; if cleared
    DEC PWM_INC_VAL;
        BRNE TOGGLE_PWM_STATUS;
    RET;

set_PWM_INC_VAL:
    tfr_to_reg PWM_INC_VAL,230;
    ret;

TOGGLE_PWM_STATUS:
    tgl_tfr_reg status_regA,PWM_dir_bit; toggle it
    rcall set_PWM_INC_VAL;
    RET;

do_a_ret_thingy:
    RET;

put_pwm_up:
    ldi pwm_val_store,255;
    ldi transfer_regA, 12;
    clr transfer_regB;
    or transfer_regB, PWM_INC_VAL;
    sub pwm_val_store,transfer_regB;
    add pwm_val_store,transfer_regA;
    clr transfer_regB;
    ret;

put_pwm_down:
    ldi transfer_regA, 12;
    clr transfer_regB;
    or transfer_regB, PWM_INC_VAL; 
    add transfer_regB,transfer_regA;
    or pwm_val_store,transfer_regB;
    clr transfer_regB;
    ret;

