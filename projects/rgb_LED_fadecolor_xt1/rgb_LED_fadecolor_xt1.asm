;this program will do PWM to fade RGB led on PB2-4
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

.def B = r25;

.def status_regA = r17;
.def transfer_regA = r18;
.def transfer_regB = r23;
.def tgl_io_regA = r21;
.def tgl_io_regB = r22;
.def pwm_val_store = r19; to store the PWM val (0-255);
.def pwm_calc_store = r20;

.def PWM_INC_VAL = r13; to store increments to PWM in a counter

.def LED_RGB_SEL = r24; to store which led is avtivated
.equ LED_R_bit = 2;R
.equ LED_G_bit = 1;G
.equ LED_B_bit = 0;B

.equ LED_status_bit = 7;

.equ PWM_dir_bit = 1; bit for PWM direction status in status_regA
.equ PWM_flag_bit = 2;


;****MACROS****;
.macro tgl_io
	in tgl_io_regA, @0; input the io data in first arg
	ldi  tgl_io_regB, (1<<@1); input the 2nd arg bit to reg b
	eor tgl_io_regA, tgl_io_regB; toggle the bit in other reg
	out @0, tgl_io_regA; send it back to the io PORTx in 1st arg
.endmacro

;.macro tgl_io_byte
;;
;	in tgl_io_regA, @0; input the io data in first arg
;	ldi  tgl_io_regB, @1; input the 2nd arg bit to reg b
;	eor tgl_io_regA, tgl_io_regB; toggle the bit in other reg
;	out @0, tgl_io_regA; send it back to the io PORTx in 1st arg
;
;.endmacro

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
    
    
    ;setup sleep stuff
    ldi A, (1<<SE);set sleep enable
    out MCUCR,A; 
    
    ;SBI DDRB,PB0        ;SET PORTB0 FOR OUTPUT by setting bit 0 in DDRB
    ldi A,0b00011100;set PB2-4 to output
    out DDRB,A; load into DDRB
    ldi LED_RGB_SEL,0b00000100; set to start with Red (bit2)
    
    ori status_regA, (1<<PWM_dir_bit);//set the direction to always be up
    
    ;tgl_io PORTB,3;
    ldi A, 0b00001100;
    out PORTB,A;
    
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
    sleep; sleep
       RJMP MAIN_LOOP

;----------------------------------;
; TIMER OVER-FLOW INTERUPT ROUTINE ;
;----------------------------------;
TIM0_OVF:
    ;nop;
    ;nop;
    ;nop;
    ;nop;
    
    ;tgl_io   PORTB,0       ;FLIP THE 0 BIT in PORTB to toggle PBO
    
    ;clr A;
    ldi A,(1<<LED_status_bit); xor toggle led status bit
    eor LED_RGB_SEL,A;
    clr A;
    ;tgl_tfr_reg LED_RGB_SEL,LED_status_bit;toggle
    
    rcall WHICH_TOGGLE;
    
    
    
    rcall PWM_INC; call the PWM_INC subroutine to change PWM val

    

    ldi pwm_calc_store,255; reset to 255
    sub pwm_calc_store,pwm_val_store; subtract from 255 to get cnt value
                                        ;to set to get PWM ON time
    ;sbis PORTB,0;skip if bit 0 is 1,
    sbrs LED_RGB_SEL,LED_status_bit;
        out TCNT0, pwm_calc_store; set counter 
    ;sbic PORTB,0;skip if bit 0 is 0
    sbrc LED_RGB_SEL,LED_status_bit;
        out TCNT0,pwm_val_store; set counter  
    
    ;ldi A,(1<<LED_status_bit); xor toggle led status bit
    ;eor LED_RGB_SEL,A;
    ;clr A;
    nop;misterious NOPs that make the code work
    nop;
    nop;
    nop;
    nop;
    
    RETI; return from the interrupt service routine

SWITCH_LED:
    
    rcall WHICH_TOGGLE;
    
    clr A;
    sbrc LED_RGB_SEL,LED_R_bit; skip if clear
        ldi A, 0b00000010;set to G in A
    sbrc LED_RGB_SEL,LED_G_bit; skip if clear
        ldi A, 0b00000001;set to B
    sbrc LED_RGB_SEL,LED_B_bit; skip if clear
        ldi A, 0b00000100;set to R
    
    sbrc LED_RGB_SEL,LED_status_bit;if clear skip
        ori A, (1<<LED_status_bit); if set then set in A as well to preserve it.
    
    mov LED_RGB_SEL,A; put reg A into other reg
    clr A;
    ;cbr status_regA, (1<<PWM_flag_bit); clear the PWM_flag_bit
    
    ;rcall WHICH_TOGGLE;
    cbr status_regA, (1<<PWM_flag_bit); clear the PWM_flag_bit
    ret;
    
WHICH_TOGGLE:
    clr A;
    sbrc LED_RGB_SEL,LED_R_bit;
        ldi A,0b00010100;
    sbrc LED_RGB_SEL,LED_G_bit;
        ldi A,0b00011000;
    sbrc LED_RGB_SEL,LED_B_bit;
        ldi A,0b00001100;
    
    ;in tgl_io_regA,PORTB;
    ;eor tgl_io_regA,A; xor toggle the bits
    ;out PORTB, tgl_io_regA; put to port
    
    in B,PORTB;
    eor B,A; xor toggle the bits
    out PORTB, B; put to port
    
    ;ldi A,(1<<LED_status_bit); xor toggle led status bit
    ;eor LED_RGB_SEL,A;
    
    clr A;
    ret;


PWM_INC:
    sbrs status_regA,PWM_dir_bit; skip if set
        rcall put_pwm_down; call the put_pwm_dowm subroutine
    sbrc status_regA,PWM_dir_bit; skip if cleared
        rcall put_pwm_up; call the put_pwm_up subroutine
    
    sbrc status_regA,PWM_flag_bit; skip if flag is clear
        ;rcall TOGGLE_PWM_STATUS; call the TOGGLE_PWM_STATUS subroutine
        rcall SWITCH_LED; switch led
    RET; return from subroutine

TOGGLE_PWM_STATUS: ;toggles the PWM change direction (up or down)
    tgl_tfr_reg status_regA,PWM_dir_bit; toggle it
    cbr status_regA, (1<<PWM_flag_bit); clear the PWM_flag_bit
    RET; return from subroutine

STORE_PWM:
    clr pwm_val_store; clear the pwm storage before new value
    or pwm_val_store,PWM_INC_VAL; OR the PWM_INC_VAL into pwm_val_store
    ret; return from subroutine

put_pwm_up:
    inc PWM_INC_VAL; increment PWM_INC_VAL up by one
        BRNE STORE_PWM; if not equal to zero then store the value
    clr pwm_val_store; if it equals zero
    ldi pwm_val_store,255;set it to 255 so it doesn't flicker before fading
    tgl_tfr_reg status_regA,PWM_flag_bit; toggle the PWM_flag_bit
    ret; return from subroutine

put_pwm_down:
    dec PWM_INC_VAL; decrement PWM_INC_VAL dowm by one
        BRNE STORE_PWM; if not equal to zero, then store it
    tgl_tfr_reg status_regA,PWM_flag_bit; otherwise toggle the flag.
    ret; return from subroutine

