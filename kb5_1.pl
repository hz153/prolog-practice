% cut的一大作用就是提高程序的效率，即部分cut并不会影响程序的陈述性意义
% 在这个程序中一旦进入！后，程序就不会回溯而是直接中断
% 例如x<3成立，程序将进入！,如果之后有条件判断为false则程序直接返回false而不会回溯匹配其他规则
% 可以通过trace.来查看程序运行状况
f(X, 0):-
X < 3, !.
f(X, 2):-
3 =< X, X < 6, !.
f(X, 4):-
6 =< X, !.
% 改进版本的函数，通过！可以让程序匹配正确一次就不再匹配
% 相比上面的程序，下面的程序效率更高，并且更加简洁
% 但是如果不加！则程序在匹配成功<3后还会继续匹配<6进而造成错误
f1(X, 0):-
X < 3, !.
f1(X, 2):-
X < 6, !.
f1(X, 4).
% 包含cut的那个子句相匹配的目标作为父目标
% 当程序读到cut时，父目标和cut之间的目标将不能进行回溯
% 也就是他们的解固定了，不能再搜索其余的解，然而cut之后的目标还可以进行回溯

% cut可以用于互斥的情况下约简整个约束,例如在比较max的时候，要么就是>=要么就是<
% 可以使用cut让代码更简洁
max(X, Y, X):-
X >= Y, !.
max(X, Y, Y).
% 当找到第一个X属于List的时候就可以退出member了
member(X, [X|List]):- !.

member(X, [Y|List]):-
member(X, List).
% ！不仅可以用于提高程序效率，还会改变语义
% 下面的程序是判断X是否是List中的元素，如果不是则把X加入进去
% 如何没有cut则有可能在回溯的时候又把X加到List中，即返回多种情况
% 要注意子句的顺序
add(X, List, List):-member(X, List), !.
add(X, List, [X|List]).
% cut往往可以用于表示存在的含义，即匹配一次，如果匹配到了则不再匹配，直接返回结果
% 注意cut可以用于描述互斥的情况
% 使用cut时，要把判断条件最多的先写出来
beat(tom, jim).
beat(ann, tom).
beat(pat, jim).

class(X, fighter):-
beat(X, _),
beat(_, X), !.
% 存在被打倒的情况互斥的是不存在被打倒的情况
class(X, winner):-
beat(X, _), !.
class(X, sportsman):-
beat(_, X).
add1(X, List, [X|List]).
% 练习5-1
% p(X),!,p(Y)在这个情况下，p(X)被匹配后就被确定了，不会再进行回溯
p(1).
p(2):- !.
p(3).
% 练习5-2
class1(Number, positive):-
Number>0, !.
class1(0, zero):- !.
class1(Number, negtive).
% 练习5-3
split([],[],[]).
% 通过增加cut后，可以省去判断X为negtive（因为是互斥的情况），从而提高程序效率
split([X|Numbers], Positive, Negative):-
class1(X, Y), 
Y \= negtive, !,
add1(X, Positive1, Positive),
split(Numbers, Positive1, Negative).

split([X|Numbers], Positive, Negative):-
add1(X, Negative1, Negative),
split(Numbers, Positive, Negative1).

% 如果需要表示mary喜欢除了蛇的所有动物，就需要使用cut+否定
% cut可以用于表示存在
% prolog中fail和false都可以表示真值为假
different(X, X):-!, fail.

different(X, Y).
% 写not逻辑，注意，这个P不能是原子命题，必须是谓词命题，并且这个命题必须有真值
% 这里的P实际上可以被看作是真值，如果P=true，那么则notP=false
% 可以通过定义操作符来让not看起来更加自然，注意fx和fy的区别
:-op(50, fy, not).
not P:-
P, !, fail;
true.
% 练习5-4,再candidate和ruleout表中找到在前者而不在后者的所有元素
find_element([], _, []).

find_element([X|Candidate], Ruleout, List):-
member(X, Ruleout),
find_element(Candidate, Ruleout, List);
add1(X, List1, List),
find_element(Candidate, Ruleout, List1).
% 练习5-5
difference(X, Y, Diff_list):-
find_element(X, Y, Diff_list).
% 总结：cut的两个作用
% 1.可以改进程序的效率，告诉prolog别去试其他的可选选项，因为注定是错的
% 2.cut可以适用于互斥的条件，最重要的是可以表示存在
% 如果存在条件P则Q否则就R
% cut分为红cut和绿cut，红cut对程序的陈述性意义有影响，而绿cut则没有
% cut前面的目标相当于被锁定住了，一旦通过了这些目标并进入cut后，当匹配出错则直接返回头目标，并且不再回溯
