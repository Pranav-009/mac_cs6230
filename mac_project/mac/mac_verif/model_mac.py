import cocotb
from cocotb_coverage.coverage import *

counter_coverage = coverage_section(
    CoverPoint('top.getResult_a', vname='getResult_a', bins = list(range(0,256))),
    CoverPoint('top.getResult_b', vname='getResult_b', bins = list(range(0,256))),
    CoverPoint('top.getResult_c', vname='getResult_c', bins = list(range(0,256))),
    CoverCross('top.cross_cover', items = ['top.getResult_a', 'top.getResult_b', 'top.getResult_c'])
)
@counter_coverage
def model_mac(A, B: int, C: int) -> int:
    return A*B + C
