# =========================================================================
# CONFIGURACIÓN GENERAL DEL PROYECTO HUB75E
# =========================================================================
TARGET    = hub75e_led_anim
TOP       = hub75e_led_anim
BUILD_DIR = build

# --- COMMON OBJECTS (Archivos fuente reutilizables en la carpeta) --------
COMMON_SRCS = control.v count.v memory.v comp.v mux1.v shift_reg.v

# Fuentes del hardware real para el TOP principal
SRCS = $(COMMON_SRCS) hub75e_led_anim.v

# Variables por defecto para simulación genérica
TB ?= ./TB/hub75e_led1_TB.v
SIM_SRCS ?= $(SRCS)

# Extracción dinámica de las celdas de simulación ECP5 usando Yosys
ECP5_SIM_CELLS  = $(shell yosys-config --datdir/ecp5/cells_sim.v)
ECP5_SIM_CELLS += $(shell yosys-config --datdir/ecp5/cells_bb.v)

# =========================================================================
# REGLAS PRINCIPALES
# =========================================================================
.PHONY: all sim sim_post synth pnr bitstream flash clean

all: bitstream

# =========================================================================
# SIMULACIÓN COMPORTAMENTAL (Dinámica para cualquier archivo .v)
# =========================================================================
sim:
	rm -f a.out *.vcd
	iverilog -g2012 -o a.out $(TB) $(SIM_SRCS)
	vvp a.out
	@if [ -f *.vcd ]; then \
		gtkwave *.vcd & \
	else \
		echo "No se generó archivo VCD automáticamente."; \
	fi

# =========================================================================
# SIMULACIÓN POST-SÍNTESIS (Estructural / Después de Sintetizar)
# =========================================================================
sim_post: $(SRCS)
	mkdir -p $(BUILD_DIR)
	rm -f $(BUILD_DIR)/*_PS.vpp *.vcd
	yosys -v3 -l $(BUILD_DIR)/synth_post.log -p 'synth_ecp5 -top $(TOP) -json $(BUILD_DIR)/$(TARGET).json; write_verilog -attr2comment $(BUILD_DIR)/$(TARGET)_synth.v' $(SRCS)
	iverilog -g2012 -DSYNTH -o $(BUILD_DIR)/$(TARGET)_PS.vpp -s hub75e_led1_TB $(TB) $(BUILD_DIR)/$(TARGET)_synth.v $(ECP5_SIM_CELLS)
	vvp $(BUILD_DIR)/$(TARGET)_PS.vpp
	gtkwave hub75e_led1_TB.vcd &

# =========================================================================
# FLUJO DE COMPILACIÓN FÍSICA
# =========================================================================

$(TARGET).json: $(SRCS)
	mkdir -p $(BUILD_DIR)
	yosys -v3 -l $(BUILD_DIR)/synth.log -p 'read_verilog $(SRCS); hierarchy -top $(TOP) -chparam NUM_FRAMES $(NUM_FRAMES) -chparam FPS $(FPS); synth_ecp5 -top $(TOP) -json $(BUILD_DIR)/$@'

$(TARGET)_out.config: $(TARGET).json $(TARGET).lpf
	nextpnr-ecp5 --json $(BUILD_DIR)/$< \
	             --lpf $(TARGET).lpf \
	             --textcfg $(BUILD_DIR)/$@ \
	             --25k \
	             --package CABGA256 \
	             --speed 6 \
	             --log $(BUILD_DIR)/pnr.log

$(TARGET).bit: $(TARGET)_out.config
	ecppack --compress $(BUILD_DIR)/$< --bit $(BUILD_DIR)/$@

synth: $(TARGET).json
pnr: $(TARGET)_out.config
bitstream: $(TARGET).bit

# =========================================================================
# CARGA DE BITSTREAM
# =========================================================================
flash: $(TARGET).bit
	sudo openFPGALoader -c ft232RL --pins=TXD:RXD:CTS:RTS $(BUILD_DIR)/$(TARGET).bit
flash-fw: $(TARGET).bit
	sudo openFPGALoader -c ft232RL -f --pins=TXD:RXD:CTS:RTS $(BUILD_DIR)/$(TARGET).bit

# =========================================================================
# LIMPIEZA
# =========================================================================
clean:
	rm -rf $(BUILD_DIR) a.out *.vcd *.log

# =========================================================================
# CONFIGURACIÓN DINÁMICA DE ANIMACIÓN
# =========================================================================
-include anim_config.mk

NUM_FRAMES ?= 4
FPS        ?= 15

# =========================================================================
# COMANDOS DE ANIMACIÓN AUTOMÁTICOS
# =========================================================================

luffy:
	@echo ">> Preparando animación de Luffy..."
	cd img && python video_to_hex.py luffy.mp4 -ct 9 -cb 9 -o ../image.hex --mk-config ../anim_config.mk
	$(MAKE) flash

nyan:
	@echo ">> Preparando animación de Nyan Cat..."
	cd img && python video_to_hex.py nyan_cat.mp4 -ct 700 -cb 700 -f 15 -cr 1000 -o ../image.hex --mk-config ../anim_config.mk
	$(MAKE) flash

badapple:
	@echo ">> Procesando Bad Apple"
	cd img && python video_to_hex.py bad_apple.mp4 -s 200 -f 40 --fps 4 -o ../image.hex --mk-config ../anim_config.mk
	$(MAKE) flash-fw
doom:
	@echo ">> Procesando Doom"
	cd img && python video_to_hex.py doom.mp4 -s 100 -r cw -f 40 --fps 5 -o ../image.hex --mk-config ../anim_config.mk
	$(MAKE) flash
# Comando universal para pasarle cualquier video desde la terminal
auto:
	@if [ -z "$(VIDEO)" ]; then echo "Error: Usa make auto VIDEO=nombre.mp4"; exit 1; fi
	@echo ">> Procesando $(VIDEO)..."
	cd img && python video_to_hex.py $(VIDEO) -o ../image.hex --mk-config ../anim_config.mk
	$(MAKE) flash
