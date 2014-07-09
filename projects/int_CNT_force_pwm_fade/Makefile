MCU=attiny11
TARGET = int_CNT_force_pwm_fade
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
