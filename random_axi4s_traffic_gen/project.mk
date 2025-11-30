# Vivado Project Makefile

VIVADO := vivado

MAKEFILE_DIR := /home/sam/FPGA/test_projects/FPGA/random_axi4s_traffic_gen

PROJ := random_axi4s_traffic_generator
PART := xc7z020clg400-1
SRC := $(MAKEFILE_DIR)/src

.PHONY: all create clean

all: create 

create:
	$(VIVADO)  -nolog -nojournal -mode batch -source $(MAKEFILE_DIR)/scripts/create_project.tcl -tclargs $(PROJ) $(PART) $(SRC)

clean:
	rm -rf $(MAKEFILE_DIR)/xilinx/*