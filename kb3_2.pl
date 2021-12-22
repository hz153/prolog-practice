conc([], L, L).
conc([X|L1], L2, [X|L3]):-
conc(L1, L2, L3).
% 练习3-3
evenlength([]).
oddlength([_]).
evenlength([_|List]):-
oddlength(List).
oddlength([_|List]):-
evenlength(List).
% 练习3-4
reverse([], []).
reverse([X|List], R_List):-
conc(R_List1, [X], R_List),
reverse(List, R_List1).
% 练习3-5
palindrome(List, P_list):-
reverse(List, P_list).
% 练习3-6
shift([X|List], Sf_list):-
conc(List, [X], Sf_list).
% 练习3-7 参照练习3-4的思路，可以用作自然语言处理的参考代码
means(0, zero).
means(1, one).
means(2, two).
means(3, three).
means(4, four).
means(5, five).
translate([], []).
translate([X|List], T_list):-
means(X, X1),
conc([X1], T_list1, T_list),
translate(List, T_list1).
% 练习3-9,如果要均衡分配，那么需要交替把元素分配给D1_list和D2_list
add(X, L, [X|L]).

dividilist([], [], []).

dividilist([X|List], D1_List, D2_List):-
add(X, D1_list1, D1_List),
dividilist(List, D2_List, D1_list1).

% 练习3-10,返回猴子抓香蕉的整个过程
move(state(middle, onbox, middle, hasnot),
	grasp,
	state(middle, onbox, middle, has)).

move(state(P, onfloor, P, H),
	climb,
	state(P, onbox, P, H)).

move(state(P1, onfloor, P1, H),
	push(P1, P2),
	state(P2, onfloor, P2, H)).

move(state(P1, onfloor, P, H),
	walk(P1, P2),
	state(P2, onfloor, P, H)).
% 定义规则
canget(state(_, _, _, has), []).
canget(State1, Actions) :- 
move(State1, Move, State2),
add(Move, Actions1, Actions),
canget(State2, Actions1).
% 3-11把表展平
flatten([], []).

flatten([X|List], F_list):-
flatten(X, F_list1),
flatten(List, F_list2),
conc(F_list1, F_list2, F_list).

flatten(X, [X]).