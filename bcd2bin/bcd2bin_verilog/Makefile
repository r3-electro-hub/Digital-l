TARGET = bcd2bin
TB = ./TB/$(TARGET)_TB.v

OBJS = \
	right_shift_reg.v\
 	control.v\
	bcd2bin.v\
	count.v\
	mux2.v\
	reg_msb.v\
	sum.v

ICE40_SIM_CELLS = ./lattice_sim/cells_sim_ecp5.v

sim:
	rm -f a.out *.vcd
	iverilog -g2012 -DBENCH -o sim.out $(TB) $(OBJS)
	vvp sim.out
	gtkwave $(TARGET)_TB.vcd

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
	rm -rf *.svg *.out *.dot *.json

	yosys -p "\
		read_verilog $(OBJS); \
		prep -top $(TARGET); \
		memory_map; \
		opt; \
		opt_expr; \
		techmap; \
		abc; \
		write_json $(TARGET).json \
	"

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