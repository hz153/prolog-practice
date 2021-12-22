% 数组操作
member(X, [X|Tail]).
member(X, [_|Tail]):-
member(X, Tail).

conc([], L, L).
conc([X|L1], L2, [X|L3]):-
conc(L1, L2, L3).

member(X, L):-
conc(_, [X|_], L).
% 练习3.2
last(Item, [Item|[]]).
last(Item, [_| Tail]):-
last(Item, Tail).

last(Item, List):-
conc(_, [Item|[]], List).
% 增加一个项进入L表中
add(X, L, [X|L]).
% 从表L中删除一个项
del(X, [X|L], L).
del(X, [Y|L1], [Y|L2]):-
del(X, L1, L2).
% 向表L中插入一个项
insert(X, L, L1):-
del(X, L1, L).
% 检测子表
sublist(S, L):-
conc(_, L2, L),
conc(S, _, L2).
% 排列表，相当于拿出顶部的元素，然后把剩余的排列完再以此插入
permutation([], []).
permutation([X|L], P):-
permutation(L, L1),
insert(X, L1, P).
% 另一种想法是现决定顶部元素在排列中的位置，然后将剩余的再进行排列
permutation2([], []).
permutation2(P, [X|L]):-
del(X, P, P1),
permutation2(P1, L).

