import sys
import math 
from eth_abi import encode

# python exp.py 18446744073709551616 
# 2.718...

x = float(sys.argv[1]) / 2**64
y = math.exp(x)

# debug
# print(y)

# check y < 2**64
assert y < 2**64,f"x = {x}"
y = int(y * 2**64)

# Encode
y = "0x" + encode(["uint256"], [y]).hex()
print(y)
