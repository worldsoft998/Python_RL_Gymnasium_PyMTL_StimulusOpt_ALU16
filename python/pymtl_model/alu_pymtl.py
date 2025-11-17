from pymtl3 import *
class ALU16(Component):
    def construct(s):
        s.op = InPort(Bits4)
        s.a  = InPort(Bits16)
        s.b  = InPort(Bits16)
        s.y  = OutPort(Bits16)
        s.z  = OutPort(Bits1)
        s.c  = OutPort(Bits1)
        s.v  = OutPort(Bits1)
        @update
        def comb():
            a = int(s.a)
            b = int(s.b)
            if int(s.op) == 0:
                res = a + b
            elif int(s.op) == 1:
                res = a - b
            else:
                res = a + b
            y = res & 0xffff
            s.y @= y
            s.c @= (res >> 16) & 1
            s.z @= 1 if y == 0 else 0
            s.v @= 0
