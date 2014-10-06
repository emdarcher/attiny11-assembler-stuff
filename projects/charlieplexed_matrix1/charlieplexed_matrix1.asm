; code to drive a charlieplexed led matrix

.include "tn11def.inc"

.def regA, r16;

;add .db stuff here I guess
;
CHAR_DB:
.db 0b10001111,0b10001111;E
.db 0b00001111,0b01001111;ET 
.db 0b01000100,0b00000100;T

.org 0000
    rjmp RESET;

RESET:
    ;setup stuff here

    ; then go to MAIN
    rjmp MAIN;

MAIN:
    ; main stuff goes here


