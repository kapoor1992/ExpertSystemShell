% Indicates what can be traced for proving.
% Requirement for the expert system shell.
traceable(move, [exit, fail]).

% Main predicate.
% Requirement for the expert system shell.
execute(Result) :-
    find_path([e,e,e,e], [w,w,w,w], Result).

% Finds path.
find_path(Start, End, Result) :-
    path(Start, End, [Start], Result).

% Base case.
% End reached, save solution.
path(End, End, Visited, Result) :-
    Result = Visited.

% Recursive case.
% Performs DFS search.
path(Current, End, Visited, Result) :-
    move(Current, Next),                 % Get next state.
    not(member(Next, Visited)),          % Check legality.
    push(Visited, Next, NewVisited),     % Add to stack.
    path(Next, End, NewVisited, Result). % Move on.

% Farmer moves with the goat.
move([Farmer, Goat, Wolf, Cabbage], Result) :-
    Farmer == Goat,
    update_pos(Farmer, NewFarmer),
    update_pos(Goat, NewGoat),
    Result = [NewFarmer, NewGoat, Wolf, Cabbage].

% Farmer moves with the wolf.
move([Farmer, Goat, Wolf, Cabbage], Result) :-
    Farmer == Wolf,
    not(Goat == Cabbage),
    update_pos(Farmer, NewFarmer),
    update_pos(Wolf, NewWolf),
    Result = [NewFarmer, Goat, NewWolf, Cabbage].

% Farmer moves with the cabbage.
move([Farmer, Goat, Wolf, Cabbage], Result) :-
    Farmer == Cabbage,
    not(Goat == Wolf),
    update_pos(Farmer, NewFarmer),
    update_pos(Cabbage, NewCabbage),
    Result = [NewFarmer, Goat, Wolf, NewCabbage].

% Farmer moves alone.
move([Farmer, Goat, Wolf, Cabbage], Result) :-
    Wolf == Cabbage,
    update_pos(Farmer, NewFarmer),
    Result = [NewFarmer, Goat, Wolf, Cabbage].

% Swaps position.
update_pos(e, w).

% Swaps position.
update_pos(w, e).

% Adds to top of stack.
push(Stack, Element, FinalResult) :-
    atom_to_list(Element, Result),
    append(Stack, Result, FinalResult).

% Allows append operation to be used.
atom_to_list(Atom, [Atom]).