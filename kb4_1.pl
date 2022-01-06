% prolog是一种十分适合数据库的语言
% 无需实际说明这些对象所有成员的情况下，就可以谈论这些对象
% prolog可以让我们使用匿名变量隐去哪些我们不感兴趣的信息
% prolog具有极强的数据表示能力，可以通过结构体，数组组织数据
% 例子1
% 数据库
family(
	person(tom, fox, date(7, may, 1950), works(bbc, 15200)),
	person(ann, fox, date(9, may, 1951), umemployed),
	[person(pat, fox, date(5, may, 1973), umemployed),
	person(lim, fox, date(5, may, 1973), umemployed)]).

family(
	person(jim, luis, date(11, may, 1950), works(cnn, 14200)),
	person(hat, luis, date(2, july, 1949), works(IBM, 20000)),
	[person(jenny, luis, date(12, june, 1975), umemployed),
	person(june, luis, date(5, april, 1976), umemployed),
	person(judy, luis, date(24, may, 1977), umemployed)]).
% 数据库查询的接口

hasband(X):-
family(X, _, _).

wife(X):-
family(_, X, _).

child(X):-
family(_, _, Children),
member(X, Children).

children(X):-
family(_, _, X).

nthchild(N, Child):-
children(ChildList),
nth_member(N, ChildList, Child).

exists(X):-
hasband(X);
wife(X);
child(X).
% \=的意思是不等于，或者说是不合一
birthday(person(_, _, date(Day, Month ,Year), _), Day, Month ,Year).
twins(Child1, Child2):-
child(Child1),
child(Child2),
birthday(Child1, Day1, Month1 ,Year1),
birthday(Child2, Day2, Month2 ,Year2),
Child1 \= Child2,
Day1 = Day2,
Month1 = Month2,
Year1 = Year2.

member(X, [X|List]).
member(X, [Y|L]):-
member(X, L).

add(X, List, [X|List]).

% prolog中的选择器结构selector(object， selected_component).
% 查询器的问题在于需要输入object
% 查询器和查询接口混用，例如：?-child(X),firstname(X, lim).
firstname(person(Firstname, _, _, _), Firstname).

salary(person(_, _, _,works(_, X)), X).
salary(person(_, _, _,umemployed), 0).

children(family(_, _, ChildList), ChildList).

nthchild(N, Family, Child):-
children(Family, ChildList),
nth_member(N, ChildList, Child).

nth_member(1, [Child|ChildList], Child).

nth_member(N, [X|ChildList], Child):-
N1 is N - 1,
nth_member(N1, ChildList, Child).

% 不确定性自动机，把一串符号串作为输入读进来，决定是否决定还是拒绝这一符号串
% 一个自动机有若干个状态，可以从当前状态转变为另一个状态
% 每当一个输入符号被读入时，就发生一次转移
% 确定执行哪一个可能的转移是由自动机完成的，自动机会尽力做出正确的转移以匹配给定的符号串
% prolog采用trans(S1,X,S2).描述状态的转移，final(S).则是状态的终结
% 下面是对p103有限自动机的描述
final(s3).
trans(s1,a,s1).
trans(s1,b,s1).
trans(s1,a,s2).
trans(s2,b,s3).
trans(s3,b,s4).
silent(s2,s4).
silent(s3,s1).
% 终止状态
accept(S,[]):-
final(S).

accept(S1, [X|List]):-
trans(S1, X, S2),
accept(S2, List).

accept(S1, List):-
silent(S1, S2),
accept(S2, List).
% 从状态s1开始的自动机
is_correct(Token_list):-
accept(s1, Token_list).
% 练习4-5
accepts(S, [], 0):-
final(S).

accepts(S1, [X|List], Count):-
Count1 is Count - 1,
trans(S1, X, S2),
accepts(S2, List, Count1).

accepts(S1, List, Count):-
silent(S1, S2),
accepts(S2, List, Count).

% 航班查询
:-op(50, xfy, :).
:-op(50, xfy, -).
:-op(100, xfy, /).
% 航班数据库
timetable(londen, zurich,
	[9:10/ 11:45/ ba614/ alldays,
	14:45/ 17:20/ sr805/ alldays]).

timetable(edinburgh, londen, 
	[9:40/ 10:50/ ba4733/ alldays,
	13:40/ 14:50/ ba4773/ alldays,
	19:40/ 20:50/ ba4833/ [mo, tu, we, th ,fr, su]]).

timetable(londen, edinburgh,
	[9:40/ 10:50/ ba4732/ alldays,
	11:40/ 12:50/ ba4752/ alldays,
	18:40/ 18:50/ ba4822/ [mo, tu, we, th, fr]]).

timetable(londen, milan,
	[8:30/ 11:20/ bs510/ alldays,
	11:00/ 13:50/ az459/ alldays]).

timetable(milan, zurich,
	[9:25/ 10:15/ sr621/ alldays,
	12:20/ 13:35/ sr623/ alldays]).

timetable(milan, londen,
	[9:10/ 10:00/ az458/ alldays,
	12:20/ 13:35/ ba511/ alldays]).

timetable(zurich, londen,
	[9:00/ 9:40/ ba613/ [mo, tu, we, th, tr, sa],
	16:10/ 16:55/ sr806/ [mo, tu, we, th, tr, su]]).

timetable(zurich, milan,
	[7:55/ 8:45/ sr620/ alldays]).

flight(Place1, Place2, Day, Fnum, Deptime, Arrtime):-
timetable(Place1, Place2, Flight_list),
member(Deptime/ Arrtime/ Fnum/ Daylist, Flight_list),
flyday(Day, Daylist).

flyday(Day, Daylist):-
member(Day, Daylist).

flyday(Day, Daylist):-
Daylist = alldays,
member(Day, [mo, tu, we, th, tr, sa, su]).
% 书中的程序有问题，可能会造成死循环，原因是缺乏航班时间的先后约束
% 然而单纯有航班时间的先后约束还不够，因为可能会出现a地-b地-a地-c地的情况
% 因此需要添加航程约束，由于在Route中已经记录了航程
% 只需要在回溯时判断出发地是否在接下来的航程中被经过，就可以添加航程约束
route(P1, P2, Day, Arrtime, [P1-P2/ Fnum/ Deptime]):-
flight(P1, P2, Day, Fnum, Deptime, Arrtime1),
can_go(Arrtime, Deptime).

route(P1, P2, Day, Arrtime, [P1-P3/ Fnum/ Deptime|Route]):-
flight(P1, P3, Day, Fnum, Deptime, Arrtime1),
can_go(Arrtime, Deptime),
route(P3, P2, Day, Arrtime1, Route),
not_inroute(P1, Route),
deptime(Route, Deptime1),
transfer(Arrtime, Deptime1).

can_go(Arr_hour:Arr_min, Dep_hour:Dep_min):-
Dep_hour > Arr_hour.

can_go(Arr_hour:Arr_min, Dep_hour:Dep_min):-
Dep_hour = Arr_hour,
Dep_min > Arr_min.

deptime([P1-P2/ Fnum/ Deptime|_], Deptime).

transfer(Arr_hour:Arr_min, Dep_hour:Dep_min):-
60 * (Dep_hour - Arr_hour) + Dep_min - Arr_min >= 40.

not_inroute(X, []).

not_inroute(X, [Y-_/ _/ _|List]):-
X \= Y,
not_inroute(X, List).

% 八皇后问题，问题求解思路：当前的棋子和已经在棋盘上的棋子不冲突
solution([], 0).

solution([X/Y|Others], Num):-
Num1 is Num - 1,
solution(Others, Num1),
member(Y, [1,2,3,4,5,6,7,8]),
member(X, [1,2,3,4,5,6,7,8]),
no_attck(X/Y, Others).

no_attck(X/Y, []).

no_attck(X/Y, [X1/Y1|Others]):-
no_attck(X/Y, Others),
X =\= X1,
Y =\= Y1,
Y1 - Y =\= X1 - X,
Y1 - Y =\= X - X1.
% 练习4-7，跳马游戏
jump(X/Y, X1/Y1):-
member(X, [1,2,3,4,5,6,7,8]),
member(Y, [1,2,3,4,5,6,7,8]),
member(X1, [1,2,3,4,5,6,7,8]),
member(Y1, [1,2,3,4,5,6,7,8]),
jump_step(X, X1, Jump_X),
jump_step(Y, Y1, Jump_Y),
jump_law(Jump_X, Jump_Y).

jump_law(Jump_X, Jump_Y):-
Jump_X = 1,
Jump_Y = 2;
Jump_X = 2,
Jump_Y = 1.

jump_step(J1, J2, Jump_step):-
max(J1, J2, Max),
min(J1, J2, Min),
Jump_step is Max - Min.
% 辅助函数
max(X1, X2, X):-
X2 - X1 >= 0,
X is X2;
X is X1.

min(X1, X2, X):-
X2 - X1 >= 0,
X is X1;
X is X2.
% 确定跳马的路径
knightpath([_/_], 0).

knightpath([X/Y|Path], Num):-
Num1 is Num - 1,
jump(X/Y, X1/Y1),
is_member(X1/Y1, Path),
knightpath(Path, Num1).
% 改写的member函数
is_member(X/Y, [X/Y|_]).

is_member(X/Y, [X1/Y1|Path]):-
is_member(X/Y, Path).

