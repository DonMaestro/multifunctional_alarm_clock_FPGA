
SOURCES=tb_display.v display.v rom.v
SOURCES_DIR= -y Components
OUTPUT_DIR=Debug/
OUTPUT_NAME=display.out
OUTPUT_WAVE=display.vcd

all: compile
	vvp $(OUTPUT_DIR)$(OUTPUT_NAME)


compile: $(SOURCES)
	iverilog -o $(OUTPUT_DIR)$(OUTPUT_NAME) $(SOURCES) $(SOURCES_DIR)


wave: compile
	vvp $(OUTPUT_DIR)$(OUTPUT_NAME)
	gtkwave $(OUTPUT_DIR)$(OUTPUT_WAVE)


