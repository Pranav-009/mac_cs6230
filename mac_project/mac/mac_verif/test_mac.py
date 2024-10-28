# This file is public domain, it can be freely copied without restrictions.
# SPDX-License-Identifier: CC0-1.0

import os
import random
from pathlib import Path

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
from model_mac import *

@cocotb.test()
async def test_mac(dut):
    """Test to check counter"""

    dut.EN_increment.value = 0
    dut.EN_decrement.value = 0

    clock = Clock(dut.CLK, 10, units="us")  # Create a 10us period clock on port clk
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))
    dut.RST_N.value = 0
    await RisingEdge(dut.CLK)
    dut.RST_N.value = 1
    dut.EN_increment.value = 1
    dut.increment_di.value = 10
    dut._log.info('Incrementing')
    for i in range(0,10):
        await RisingEdge(dut.CLK)
        dut._log.info(f'output {int(dut.read.value)}')

    dut._log.info('No change')
    dut.increment_di.value = 0
    dut.decrement_dd.value = 0
    for i in range(0,4):
        await RisingEdge(dut.CLK)
        dut._log.info(f'output {int(dut.read.value)}')

    dut.EN_increment.value = 0
    dut.EN_decrement.value = 1
    dut.decrement_dd.value = 5
    dut._log.info('Decrementing')
    for i in range(0,5):
        await RisingEdge(dut.CLK)
        dut._log.info(f'output {int(dut.read.value)}')

    ## test using model
    dut.RST_N.value = 0
    await RisingEdge(dut.CLK)
    dut.RST_N.value = 1
    dut.EN_increment.value = 1
    dut.increment_di.value = 10
    dut._log.info('Incrementing')

    for i in range(0, 5):
        en = int(dut.EN_increment.value)
        value = int(dut.increment_di.value)
        ini = int(dut.read.value)

        await RisingEdge(dut.CLK)
        dut._log.info(f'output {int(dut.read.value)}')
        
        counter_out = model_counter(ini, en, value)
        assert int(counter_out) == int(dut.read.value), f'Counter Output Mismatch, Expected = {counter_out} DUT = {int(dut.read.value)}'
    
    coverage_db.export_to_yaml(filename="coverage_counter.yml")

