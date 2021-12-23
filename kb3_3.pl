% prolog中算子的定义
:-op(700, xfx, <===>).
:-op(550, xfy, and).
:-op(500 ,xfy, or).
:-op(450, fy, not).

not(not(P))<===>P.
not(A and B)<===>not A or not B.
