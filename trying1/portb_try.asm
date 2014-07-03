
.org 0x0000
rjmp main
 
main:
ldi r16, 0xFF
out DDRB, r16
loop:
rjmp loop 	; the next instruction has to be written to address 0x0000
; the reset vector: jump to "main"
;
; this is the label "main"
; load register 16 with 0xFF (all bits are 1)
; write the value in r16 (0xFF) to Data Direction Register B
; this is a new label we use for a "do nothing loop"
; jump to loop
