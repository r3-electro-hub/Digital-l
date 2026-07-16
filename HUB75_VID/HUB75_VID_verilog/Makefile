# =========================================================================
# CONFIGURACIÓN GENERAL DEL PROYECTO COLORLIGHT
# =========================================================================
TARGET    = video_controller
TOP       = video_controller
BUILD_DIR = build
LPF       = video_controller.lpf

# =========================================================================
# RUTAS Y ARCHIVOS FUENTE
# =========================================================================

# 1. TOP Padre (En la raíz del proyecto)
TOP_SRCS = video_controller.v

# 2. Carpeta RAM: Módulos de memoria de doble puerto y BRAM
RAM_SRCS = RAM/ping_pong_ram.v \
           RAM/bram.v

# 3. Carpeta SPI_LECTOR: Módulos del lector de memoria Flash SPI
SPI_SRCS = spi_slave.v

# 4. Carpeta HUB_VID: Módulos de control de pantalla, contadores y comparadores
HUB_SRCS = HUB_VID/hub75e_vid.v \
           HUB_VID/control.v \
           HUB_VID/shift_reg.v \
           HUB_VID/mux1.v \
           HUB_VID/count.v \
           HUB_VID/comp.v

# Consolidado de todas las fuentes necesarias para la síntesis física
SRCS = $(TOP_SRCS) $(RAM_SRCS) $(SPI_SRCS) $(HUB_SRCS)

# Variables por defecto para simulación (Testbench del TOP Padre)
TB       ?= ./TB/colorlight_system_top_TB.v
SIM_SRCS ?= $(SRCS)

# Extracción dinámica de las celdas de simulación ECP5 usando Yosys
ECP5_SIM_CELLS  = $(shell yosys-config --datdir/ecp5/cells_sim.v)
ECP5_SIM_CELLS += $(shell yosys-config --datdir/ecp5/cells_bb.v)

# =========================================================================
# REGLAS PRINCIPALES
# =========================================================================
.PHONY: all sim sim_post synth pnr bitstream flash flash_fw flash_video clean

all: bitstream

# =========================================================================
# SIMULACIÓN COMPORTAMENTAL
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
# SIMULACIÓN POST-SÍNTESIS (Estructural)
# =========================================================================
sim_post: $(SRCS)
	mkdir -p $(BUILD_DIR)
	rm -f $(BUILD_DIR)/*_PS.vpp *.vcd
	yosys -v3 -l $(BUILD_DIR)/synth_post.log -p 'synth_ecp5 -top $(TOP) -json $(BUILD_DIR)/$(TARGET).json; write_verilog -attr2comment $(BUILD_DIR)/$(TARGET)_synth.v' $(SRCS)
	iverilog -g2012 -DSYNTH -o $(BUILD_DIR)/$(TARGET)_PS.vpp -s colorlight_system_top_TB $(TB) $(BUILD_DIR)/$(TARGET)_synth.v $(ECP5_SIM_CELLS)
	vvp $(BUILD_DIR)/$(TARGET)_PS.vpp
	gtkwave colorlight_system_top_TB.vcd &

# =========================================================================
# FLUJO DE COMPILACIÓN FÍSICA (Yosys -> nextpnr -> ecppack)
# =========================================================================

$(TARGET).json: $(SRCS)
	mkdir -p $(BUILD_DIR)
	yosys -v3 -l $(BUILD_DIR)/synth.log -p 'read_verilog $(SRCS); hierarchy -top $(TOP) -chparam NUM_FRAMES $(NUM_FRAMES) -chparam FPS $(FPS); synth_ecp5 -top $(TOP) -json $(BUILD_DIR)/$@'

$(TARGET)_out.config: $(TARGET).json $(LPF)
	nextpnr-ecp5 --json $(BUILD_DIR)/$< \
                 --lpf $(LPF) \
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
# GRABACIÓN EN LA HARDWARE (openFPGALoader)
# =========================================================================

# Opción A: Carga rápida y volátil en la SRAM (Se borra al apagar)
flash: $(TARGET).bit
	sudo openFPGALoader -c ft232RL --pins=TXD:RXD:CTS:RTS $(BUILD_DIR)/$(TARGET).bit

# Opción B: Grabar el firmware de forma PERMANENTE en la Flash (Offset 0x000000)
flash_fw: $(TARGET).bit
	@echo ">> Grabando hardware de forma permanente en la Flash..."
	sudo openFPGALoader -c ft232RL --pins=TXD:RXD:CTS:RTS -f $(BUILD_DIR)/$(TARGET).bit

# =========================================================================
# LIMPIEZA
# =========================================================================
clean:
	rm -rf $(BUILD_DIR) a.out *.vcd *.log image.bin

# =========================================================================
# CONFIGURACIÓN DINÁMICA DE ANIMACIÓN
# =========================================================================
-include anim_config.mk

NUM_FRAMES ?= 4
FPS        ?= 15
luffy:
	@echo ">> Preparando animación de Luffy..."
	cd img && python3 video_to_hex.py luffy.mp4 -ct 9 -cb 9 -o ../image.bin --mk-config ../anim_config.mk

nyan:
	@echo ">> Preparando animación de Nyan Cat..."
	cd img && python3 video_to_hex.py nyan_cat.mp4 -ct 700 -cb 700 -f 15 -cr 1000 -o ../image.bin --mk-config ../anim_config.mk

badapple:
	@echo ">> Procesando Bad Apple..."
	cd img && python3 video_to_hex.py bad_apple.mp4 -f 900 --fps 15 -o ../image.bin --mk-config ../anim_config.mk

doom:
	@echo ">> Procesando Doom..."
	cd img && python3 video_to_hex.py doom.mp4 -s 100 -r cw -f 40 --fps 5 -o ../image.bin --mk-config ../anim_config.mk

auto:
	@if [ -z "$(VIDEO)" ]; then echo "Error: Usa make auto VIDEO=nombre.mp4"; exit 1; fi
	@echo ">> Procesando $(VIDEO)..."
	cd img && python3 video_to_hex.py $(VIDEO) -o ../image.bin --mk-config ../anim_config.m