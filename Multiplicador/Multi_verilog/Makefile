TARGET = multiplicador
TB = $(TARGET)_TB.v

OBJS = \
	accum.v \
	comparador.v \
	control.v \
	left_shift.v \
	right_shift.v \
	multiplicador.v
ICE40_SIM_CELLS = ./lattice_sim/cells_sim_ecp5.v

sim:
	rm -f a.out *.vcd
	iverilog -g2012 -DBENCH -o sim.out $(TB) $(OBJS)
	vvp sim.out
	gtkwave $(TARGET)_tb.vcd

sim_post_syn:
	yosys -v3 -l synth.log \
	-p 'synth_ecp5 -top $(TARGET) -json $(TARGET).json; write_verilog -attr2comment $(TARGET)_synth.v' \
	$(OBJS)

	iverilog -g2012 -I ./lattice_sim \
	-o sim_post.out \
	$(TB) \
	$(TARGET)_synth.v \
	$(ICE40_SIM_CELLS)

	vvp sim_post.out
	gtkwave $(TARGET)_tb.vcd

svg:
	rm -rf *.svg *.out *.dot

	yosys -p "\
	prep -top $(TARGET); \
	memory_map; \
	opt; \
	opt_expr; \
	techmap; \
	abc -g AND,OR,XOR; \
	write_json $(TARGET).json" \
	$(OBJS)

	yosys -p "\
	read_verilog $(OBJS); \
	proc; \
	memory_map; \
	opt; \
	opt_expr; \
	techmap; \
	abc -g AND,OR,XOR; \
	show -format dot -prefix $(TARGET)_out"

	netlistsvg $(TARGET).json -o $(TARGET).svg

	firefox $(TARGET).svg

clean:
	rm -rf \
	*.svg \
	*.out \
	*.dot \
	*.json \
	*.vcd \
	*_synth.v \
	*.log \
	a.out \
	sim.out \
	sim_post.out