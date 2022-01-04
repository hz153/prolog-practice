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

