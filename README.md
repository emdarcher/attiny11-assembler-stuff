git repo that stores stuff that I have done or am doing in assembly language for the Atmel AVR Attiny11(L) Microcontroller. I am using assembly language because this little mcu has no RAM (just 32 general purpose registers), so compiling C code for it is a challenge.

~~The code is assembled using `avr-as` , a part of the GNU AVR toolchain.~~

The code is now primarily being compiled by another open source assembler for AVR called `avra`, on Linux. This is due to it having better syntax compatability with the proprietary AVR Assembler in Atmel Studio, which most assembly code I found online is written for.
To use `avra` with the *.inc include files from Atmel you have to comment out any `#ifndef`,`#define`,`#pragma`, `#endif`, or anything starting with `#` so `avra` doesn't complain when assembling. Removing them doesn't mess anything up it seems.

The microcontroller is being programmed using a Atmel STK500 with firmware version 2 so I can use High Voltage Serial Programming (HVSP) through `avrdude`, an open source program for communicating with AVR ISP programmers. I use HVSP because the ATtiny11(L) can only be programmed this way ( another annoying thing about this AVR ).

The ATtiny11 has been discontinued for a while, but I got my hands on some ( plus a few other discontinued AVRs ) when my local hackerspace was cleaning stuff out, so I might as well use them. This will be an excuse to learn AVR assembly I guess.
