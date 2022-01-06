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
% prolog的计算最好的在回溯的时候写，不然会出现没有实例化的错误
% prolog在做值运算的时候，需要立马执行，而不会把变量寄存
% 并且，由于is和算符的优先级不同，is是最后运算的，所以is右边的算式必须全部都是数字常量
length1([], 0).
length1([_|List], N):-
length1(List, N1),
N is N1 + 1.
% 练习3-16
max(X, Y, Max):-
X =< Y,
Max = Y.
max(X, Y, Max):-
X > Y,
Max = X.
% 练习3-17，注意再写计算必须放在回溯中，如果是放在递归中，因为Max是变量，进行运算造成错误
% 这种因为变量没有被赋值而造成的错误，不能通过增加初始化规则来避免
% 终止条件
maxlist([], -1000).
% 使用trace后我发现在赋值的时候要重新定义一个变量，因为上一层回溯已经把Max变为常量了，所以返回只会是T/F
% 不同于过程式语言，这里要使用max，因为如果只是比较的话，比较结果是fail，则会直接退出程序
maxlist([X|List], Max):-
maxlist(List, Max1),
max(X, Max1, Max).
% 练习3-19，需要比较缓冲区顶部的元素和已经弹出的元素之间的大小关系
% 增加一个项进入L表中
add(X, L, [X|L]).
ordered([_]).
ordered([X|List]):-
add(Y, List1, List),
X < Y,
ordered(List).
% 练习3-20,比较困难
subsum([], 0, []).
subsum([X|List], Sum, Sub_set):-
Sum1 is Sum - X,
subsum(List, Sum1, Sub_set1),
add(X, Sub_set1, Sub_set).
subsum([X|List], Sum, Sub_set):-
subsum(List, Sum, Sub_set).

% 描述式范例，以下的编程方法需要仔细学习！
%subsum(Set,Sum,SubSet):-
%    isSubSet(SubSet,Set),
%    sum(Sum,SubSet).

%isSubSet([X],Set):-
%    member(X,Set).
%isSubSet([First|Others],Set):-
%    member(First,Set),
%    subtraction(Set,First,SetOthers),
%    isSubSet(Others,SetOthers).

%subtraction([First|SetOthers],First,SetOthers):-!.
%subtraction([X|Set],First,[X|SetOthers]):-
%    X \= First,
%    subtraction(Set,First,SetOthers),
%    !.

%sum(Num,[Num]).
%sum(Sum,[First|SubSet]):-
%    sum(SumRest,SubSet),
%    Sum is SumRest + First.

% 练习3-21
between(N, N, [N]).
between(N1, N2, X):-
N2 >= N1,
N11 is N1 + 1,
between(N11, N2, X1),
add(N1, X1, X).

