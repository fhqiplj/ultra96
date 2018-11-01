# Create BOOT.bin (for standalone)
# 
# Usage: In Xilinx Software Command Line Tool, run the following command:
#           source create_boot_bin.tcl
# 
# Need to install board files in <SDK Installation Path>/data/boards/board_files
#
# Reference: UG1208
# 

set XSDK_DIR    sdk
set PRJ_NAME    u96_base
set SRC_DIR     src

set SCRIPT_DIR [ file dirname [ file normalize [ info script ] ] ]

cd ${SCRIPT_DIR}

setws ${SCRIPT_DIR}/${XSDK_DIR}

# Create BSP
createhw -name bsp -hwspec ${XSDK_DIR}/${PRJ_NAME}_wrapper.hdf

# Create FSBL
createapp -name fsbl -app {Zynq MP FSBL} -hwproject bsp -proc psu_cortexa53_0 -os standalone

# Create application
createapp -name hello_world -app {Hello World} -hwproject bsp -proc psu_cortexa53_0 -os standalone

# Use UART1 as stdin & stdout 
configbsp -bsp hello_world_bsp stdin  psu_uart_1
configbsp –bsp hello_world_bsp stdout psu_uart_1

# Build in release mode
configapp -app fsbl build-config release
configapp -app hello_world build-config release

projects -build

# Generate BOOT.bin
exec bootgen -arch zynqmp -image ${SRC_DIR}/boot_bin_standalone.bif -w -o BOOT_standanlone.bin
