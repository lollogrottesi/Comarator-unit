Two different generic units are implemented for signed and unsigned numbers, both units can recognize equalities and inequalities.  

The units are done without performing the direct difference between the input operands but using only the carry network to recgonize the two basic inequalities(A-B => carryout = '1' if A >= B) the equality check is performed using a XOR-NOR network.
