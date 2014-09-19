; code to drive a charlieplexed led matrix

.include "tn11def.inc"

.def regA, r16;

;add .db stuff here I guess
;


.org 0000
    rjmp RESET;

RESET:
    ;setup stuff here

    ; then go to MAIN
    rjmp MAIN;

MAIN:
    ; main stuff goes here


