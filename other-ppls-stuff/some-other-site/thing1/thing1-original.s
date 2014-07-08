;-----------------------------------------------------------------------------
;* start.asm
;* lines beginning with ; are comments
;*
;-----------------------------------------------------------------------------
        .include "m8def.inc"   ;include definitions for ATmega8
; Reset and interrupt vectors   ;VNr. Meaning
begin:  rjmp main               ; 1   Power On Reset
        reti                    ; 2   Int0-Interrupt
        reti                    ; 3   Int1-Interrupt
        reti                    ; 4   TC2 Compare Match
        reti                    ; 5   TC2 Overflow
        reti                    ; 6   TC1 Capture
        reti                    ; 7   TC1 Compare Match A
        reti                    ; 8   TC1 Compare Match B
        reti                    ; 9   TC1 Overflow
        reti                    ; 10  TC0 Overflow
        reti                    ; 11  SPI, STC = Serial Transfer Complete
        reti                    ; 12  UART Rx Complete
        reti                    ; 13  UART Data Register Empty
        reti                    ; 14  UART Tx Complete
        reti                    ; 15  ADC Conversion Complete
        reti                    ; 16  EEPROM ready
        reti                    ; 17  Analog Comperator
        reti                    ; 18  TWI (I2C) Serial Interface
        reti                    ; 19  Store Program Memory ready
;-----------------------------------------------------------------------------
; Start, Power On, Reset
main:   ldi r16, RAMEND&0xFF
        out SPL, r16            ; Init Stackpointer L
        ldi r16, (RAMEND>>8)
        out SPH, r16            ; Init Stackpointer H

;; Init-Code
        ldi r16, 0xFF
        out DDRB, r16
        ldi r16, 0b001      ; load binary number to r16
        out PORTB, r16      ; output of r16 to PORTB
        ldi r20, 5

;-----------------------------------------------------------------------------
mainloop:
        adiw r24, 1
        brne mainloop           ;waiting loop
        subi r20, 1
        brne mainloop           ;longer waiting loop
        ldi r20, 5
        rol r16                 ;Rotation left
        cpi r16, 0x08           ;compare for last LED
        brne t1                 ;branch if not equal
        ldi r16, 1              ;otherwise set again to first LED
t1:     out PORTB, r16          ;LEDs blinking
        rjmp mainloop
