% 猴子摘香蕉问题
% 定义了四种动作grasp,push,climb,walk
% 谓词可以描述状态，关系和动作
% 采用state描述猴子、箱子、香蕉的状态
% 采用move描述猴子可以进行的动作
% 编写事实的建议，如果事实中包含的未知量越多，那么要将其尽量往后写，因为可能容易循环
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
canget(state(_, _, _, has)).
canget(State1) :- 
move(State1, Move, State2),
canget(State2).
