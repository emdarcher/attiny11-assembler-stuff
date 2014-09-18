MCU=attiny11
TARGET = charlieplexed_matrix1
ASRC = $(TARGET).asm

AS = avra

AVRDUDE = avrdude

AVRDUDE_PROGRAMMER = stk500hvsp 

AVRDUDE_PORT = /dev/ttyUSB0

AVRDUDE_WRITE_FLASH = -U flash:w:$(TARGET).hex

AVRDUDE_BASIC = -p $(MCU) -P $(AVRDUDE_PORT) -c $(AVRDUDE_PROGRAMMER)

AVRDUDE_FLAGS=$(AVRDUDE_BASIC)

all:
	$(AS) $(ASRC) 

program:
	$(AVRDUDE) $(AVRDUDE_FLAGS) $(AVRDUDE_WRITE_FLASH)

clean:
	rm *.cof *.obj  *.hex

avrdude_terminal:
	$(AVRDUDE) $(AVRDUDE_FLAGS) -nt


#for internal oscillator and ext reset enabled
DEFAULT_LFUSE = 0xfc

set_default_fuses:
	$(AVRDUDE) $(AVRDUDE_FLAGS) -U fuse:w:$(DEFAULT_LFUSE):m

EXT_RC_LFUSE = 0xfd
set_ext_RC_fuses:
	$(AVRDUDE) $(AVRDUDE_FLAGS) -U fuse:w:$(EXT_RC_LFUSE):m

EXT_CLK_LFUSE = 0xf8
set_ext_clk_fuses:
	$(AVRDUDE) $(AVRDUDE_FLAGS) -U fuse:w:$(EXT_CLK_LFUSE):m
