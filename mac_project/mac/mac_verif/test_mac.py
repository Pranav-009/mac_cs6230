import os
import random
from pathlib import Path

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
from model_mac import *

@cocotb.test()
async def test_mac(dut):

    clock = Clock(dut.CLK, 10, units="us")  # Create a 10us period clock on port clk
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))
    

    ## test using model
    dut.RST_N.value = 0
    await RisingEdge(dut.CLK)
    dut.RST_N.value = 1

    for i in range(0, 100):
        en = int(dut.getResult_a.value)
        value = int(dut.increment_di.value)
        ini = int(dut.read.value)
        
        get_a = random.randint(0,255)
        get_b = random.randint(0,255)
        get_c = random.randint(0,255)
        
        dut.getResult_a.value = get_a
        dut.getResult_b.value = get_b
        dut.getResult_c.value = get_c

        await RisingEdge(dut.CLK)
        #dut._log.info(f'output {int(dut.read.value)}')
        
        mac_out = model_mac(get_a, get_b, get_c)
        assert int(mac_out) == int(dut.getResult.value), f'MAC Output Mismatch, Expected = {mac_out} DUT = {int(dut.getResult.value)}'
    
    coverage_db.export_to_yaml(filename="coverage_mac.yml")
