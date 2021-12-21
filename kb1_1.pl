parent(anna,lily).
parent(lily,bob).
parent(bob,tom).
/*使用_而不是其他变量定义规则，可能会使程序陷入无意义的死循环中!
_让prolog不需要关注它的实例化，也就是prolog会选择变量去匹配
因此，使用_很有可能会改变使用规则的顺序*/

predecessor(X,Z):-parent(X,Z).
predecessor(X,Z):-parent(X,Y),predecessor(Y,Z).
