% prolog中算子的定义
:-op(700, xfx, <===>).
:-op(550, xfy, and).
:-op(500 ,xfy, or).
:-op(450, fy, not).

not(not(P))<===>P.
not(A and B)<===>not A or not B.
% 了解中缀表达式如何转变为逆波兰表达式
% 辗转相除法
gcd(X, X, X).

gcd(X, Y, D):-
X > Y,
gcd(Y, X, D).

gcd(X, Y, D):-
Y1 is Y - X,
gcd(X, Y1, D).

% 计算表的长度,N只是在描述当前表的长度
length1([], 0).
length1([_|List], N):-
N1 is N - 1,
length1(List, N1).

