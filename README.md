# FPGA Project: DCC Command Station on Basys3 Using MicroBlaze
This repository contains the source files for a DCC Command Station implemented on an FPGA Basys3 board using a MicroBlaze soft processor. The project focuses on controlling model trains through the DCC (Digital Command Control) protocol, which allows multiple locomotives to be controlled independently on the same track.

Project Overview
Objective
The goal of this project is to implement a DCC command station on the Basys3 FPGA board using MicroBlaze as the main processor. The station is capable of sending commands to a DCC-compatible train, controlling its speed, direction, and other functions.

Key Components
FPGA: Xilinx Basys3, powered by a Xilinx Artix-7 FPGA.
MicroBlaze: A soft processor implemented on the FPGA to handle DCC command generation.
DCC Protocol: Used for controlling multiple trains on a single track. Commands are encoded and transmitted to the tracks.
Vivado & Vitis: Xilinx toolchain used for hardware design and software development.
