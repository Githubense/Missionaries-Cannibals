% Main precidate to solve the problem
solve :-
    initial(Start), % Get initial state of the problem
    breadthfirst([[Start]] , Solution), % use bdf search to find the solution
    % Solution is a path (in reverse order) from initial to a goal
    write(Solution), % write the solution used
    nl,
    printsol(Solution). % pinrt the solution in a readable format step by steo 

% safe(NumOfMissionaries , NumOfCannibals) is true if NumOfMissionaries is 0 or 3 or equal to NumOfCannibals.
safe(0,_).
safe(3,_).
safe(X,X).

% A state is represented by a term:
% state(NumOfMissionaries, NumOfCannibals, BoatRight)

initial(state(3,3,1)).
goal(state(0,0,0)).
goalpath([Node|_]) :- goal(Node).
    
% Move states from state1 to result into state2
% move(State1, State2)

% 2 missionaries from left to right
move(	state(M1, C1, 1), 	% before move
     	state(M2, C1, 0)) 	% after move
	:- 	M1 > 1, 			% More than 1 missionary in left
    	M2 is M1-2, 		% Move 2 missionaries to right
    	safe(M2, C1).		% Check if safe move

% 2 missionaries from right to left
move(	state(M1, C1, 0), 	% before move
     	state(M2, C1, 1)) 	% after move
	:- 	M1 < 2, 			% Less than 2 missionaries in left
    	M2 is M1+2, 		% Add two missionaries to left
    	safe(M2, C1).		% Check if safe move

% 2 cannibals from left to right
move(	state(M1, C1, 1), 	% before move
     	state(M1, C2, 0)) 	% after move
	:- 	C1 > 1, 			% More than 1 cannibal in left
    	C2 is C1-2, 		% move 2 cannibals to right
    	safe(M1, C2).		% Check if safe move

% 2 cannibals from right to left
move(	state(M1, C1, 0), 	% before move
     	state(M1, C2, 1)) 	% after move
	:- 	C1 < 2, 			% Less than 2 cannibals in left
    	C2 is C1+2, 		% Add two missionaries to left
    	safe(M1, C2).		% Check if safe move

% 1 cannibal from left to right
move(	state(M1, C1, 1),	% before move
     	state(M1, C2, 0))	% after move
	:- 	C1 > 0,				% More than 0 cannibals in left
    	C2 is C1-1,			% move 1 cannibal to right
    	safe(M1, C2).		% Check if safe move

% 1 cannibal from right to left
move(	state(M1, C1, 0),	% before move
     	state(M1, C2, 1))	% after move
	:- 	C1 < 3,				% Less than 3 cannibals in left
    	C2 is C1+1,			% move 1 cannibal to right
    	safe(M1, C2).		% Check if safe move

% 1 missionary and 1 cannibal from left to right
move(	state(M1,C1,1),		% before move
     	state(M2,C2,0))		% after move
	:-	M1 > 0,				% more than 1 missionary in left
    	M2 is M1-1, 		% move 1 missionary to right
    	C1 > 0,				% more than 1 cannibal in left
    	C2 is C1-1,			% move 1 cannibal to right
    	safe(M2,C2).		% check if safe move

% 1 missionary and 1 cannibal from right to left
move(	state(M1,C1,0),		% before move
     	state(M2,C2,1))		% after move
	:-	M1 < 3,				% less than 3 missionaries in left
    	M2 is M1+1, 		% move 1 missionary to left
    	C1 < 3,				% less than 3 cannibal in left
    	C2 is C1+1,			% move 1 cannibal to left
    	safe(M2,C2).		% check if safe move

% 1 missionary moves not available since it will always be unsafe

printsol([X]) :- write(X), write(': initial state'), nl.
printsol([X,Y|Z]) :- printsol([Y | Z]), write(X), explain(Y,X), nl.

explain(state(M1,C1,1), state(M2,C2,_)) :-
    X is M1-M2, Y is C1-C2, write(': '),
    write(X), write('missionaries and '),
    write(Y), write('cannibals moved from left to right').

explain(state(M1,C1,0), state(M2,C2,_)) :-
    X is M2-M1, Y is C2-C1, write(': '),
    write(X), write('missionaries and '),
    write(Y), write('cannibals moved from right to left').

% breadthfirst([Path1, Path2, ...], Solution):
%	each Path i represents [Node | Ancestors], whre Node is in the open list and Ancestors is a path from the parent of the Node to the initial node in the search tree
%	Solution is a path in reverse from initial to a goal

breadthfirst([Path | _], Path) :-
    goalpath(Path). %if path is goal-path, then it is a solution

breadthfirst([Path | Paths], Solution) :-
    extend(Path, NewPaths),
    append(Paths, NewPaths, Paths1),
    breadthfirst(Paths1, Solution).

% setof(X, Condition, Set), is a builtin function that collects all X satisfying condition into set.

extend( [Node | Path], NewPaths) :-
    setof(	[NewNode, Node | Path],
    		(move(Node,NewNode), not(member(NewNode, [Node | Path]))),
    		NewPaths),
!.

extend(_, []).

not(P) :- P, !, fail.
not(_).