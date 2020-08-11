NAME=fpmul

FILES=$(NAME).vhd ffd.vhd delay.vhd $(NAME)_tb.vhd
TEST_ENTITY=$(NAME)_tb
WAVE_FILE=$(NAME).vcd

GHDL_ARGS=--std=93c

OBJ=$(FILES:.vhd=.o)

all: view

check:
	ghdl -s $(GHDL_ARGS) $(FILES)

$(OBJ) &: $(FILES)
	ghdl -a $(GHDL_ARGS) $(FILES)

$(TEST_ENTITY): $(OBJ)
	ghdl -e $(GHDL_ARGS) $(TEST_ENTITY)

test: $(TEST_ENTITY)
	ghdl -r $(TEST_ENTITY) --vcd=$(WAVE_FILE) --assert-level=error

view: $(TEST_ENTITY)
	ghdl -r $(GHDL_ARGS) $(TEST_ENTITY) --vcd=$(WAVE_FILE) --stop-time=360ns
	gtkwave $(WAVE_FILE)

clean:
	rm -fv $(TEST_ENTITY) $(WAVE_FILE) *.o *.cf
