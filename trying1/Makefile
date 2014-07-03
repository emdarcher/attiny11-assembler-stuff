#makefile for use with avr-as for assebly programming for AVR

MCU = attiny11
FORMAT = ihex
TARGET = main
ASRC = $(TARGET).s



# Programming support using avrdude. Settings and variables.

#AVRDUDE_PROGRAMMER = stk500v2
#for HVSP
AVRDUDE_PROGRAMMER = stk500hvsp 

AVRDUDE_PORT = /dev/ttyUSB1

AVRDUDE_WRITE_FLASH = -U flash:w:$(TARGET).hex
#AVRDUDE_WRITE_EEPROM = -U eeprom:w:$(TARGET).eep


AVRDUDE_BASIC = -p $(MCU) -P $(AVRDUDE_PORT) -c $(AVRDUDE_PROGRAMMER)

AS = avr-as
OBJCOPY = avr-objcopy
OBJDUMP = avr-objdump
SIZE = avr-size
NM = avr-nm
AVRDUDE = avrdude
REMOVE = rm -f
MV = mv -f

ASFLAGS = -Wa

ALL_ASFLAGS = -mmcu=$(MCU) $(ASFLAGS)


# Default target.
all: build

build: elf hex

elf: $(TARGET).elf
hex: $(TARGET).hex
#eep: $(TARGET).eep
lss: $(TARGET).lss 
sym: $(TARGET).sym

#with eeprom below

#build: elf hex eep
#
#elf: $(TARGET).elf
#hex: $(TARGET).hex
#eep: $(TARGET).eep
#lss: $(TARGET).lss 
#sym: $(TARGET).sym

# Program the device.  
program: $(TARGET).hex 
	$(AVRDUDE) $(AVRDUDE_FLAGS) $(AVRDUDE_WRITE_FLASH)
	
# Program the device.  with eeprom below
#program: $(TARGET).hex $(TARGET).eep
#	$(AVRDUDE) $(AVRDUDE_FLAGS) $(AVRDUDE_WRITE_FLASH) $(AVRDUDE_WRITE_EEPROM)


.SUFFIXES: .elf .hex .eep .lss .sym

.elf.hex:
#	$(OBJCOPY) -O $(FORMAT) -R .eeprom $< $@
	$(OBJCOPY) -O $(FORMAT)  $< $@


#.elf.eep:
#	-$(OBJCOPY) -j .eeprom --set-section-flags=.eeprom="alloc,load" \
#	--change-section-lma .eeprom=0 -O $(FORMAT) $< $@

# Create extended listing file from ELF output file.
.elf.lss:
	$(OBJDUMP) -h -S $< > $@

# Create a symbol table from ELF output file.
.elf.sym:
	$(NM) -n $< > $@



# Link: create ELF output file from object files.
$(TARGET).elf: $(OBJ)
	$(AS) $(ALL_ASFLAGS) $(OBJ) --output $@ $(LDFLAGS)


# Compile: create object files from C source files.
#.c.o:
#	$(CC) -c $(ALL_CFLAGS) $< -o $@ 


# Compile: create assembler files from C source files.
#.c.s:
#	$(CC) -S $(ALL_CFLAGS) $< -o $@


# Assemble: create object files from assembler source files.
.S.o:
	$(AS) -c $(ALL_ASFLAGS) $< -o $@


# Target: clean project.
clean:
	$(REMOVE) $(TARGET).hex $(TARGET).eep $(TARGET).cof $(TARGET).elf \
	$(TARGET).map $(TARGET).sym $(TARGET).lss \
	$(OBJ) $(LST) $(SRC:.s=.d)

