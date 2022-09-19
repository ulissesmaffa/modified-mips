#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2019.1 (64-bit)
#
# Filename    : elaborate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for elaborating the compiled design
#
# Generated by Vivado on Sat Dec 07 20:25:32 -03 2019
# SW Build 2552052 on Fri May 24 14:47:09 MDT 2019
#
# Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
#
# usage: elaborate.sh
#
# ****************************************************************************
set -Eeuo pipefail
echo "xelab -wto 4591017a4e434a96a6309c344a27ae7b --incr --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot teste_behav xil_defaultlib.teste -log elaborate.log"
xelab -wto 4591017a4e434a96a6309c344a27ae7b --incr --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot teste_behav xil_defaultlib.teste -log elaborate.log
