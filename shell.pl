% Keeps track of solutions already found.
:- dynamic solved/1.

% Saves the traceable components specified by the knowledge base.
% This predicate is required in the knowledge base.
:- dynamic traceable/2.

% Starts the shell.
start() :-
    clean(),        % Remove previously stored dynamic predicates.
    intro(),        % Display a welcome message for the user.
    load(),         % Get the knowledge base.
    legal(),        % Makes sure that execute/1 and traceable/2 were defined in the knowledge base.
    prompt(),       % Prompt the user for further instructions.
    read(Input),    % Read their response.
    session(Input). % Enter a session loop.

% Problems were found before session loop was entered.
start() :-
    input(end).

% Remove session specific predicates from the past.
clean() :-
    retractall(solved),    % Remove previous solutions.
    retractall(traceable). % Remove previously valid traceable components.

% Brief introduction to the shell and its usage.
intro() :-
    write('Welcome to an expert system shell written in Prolog.'),
    nl,
    write('Valid commands include \'solve\', \'how\', and \'end\'.'),
    nl,
    write('The \'how\' command can only be interpreted once \'solve\' has found a solution.'),
    nl,
    nl.

% Gets knowledge base.
load() :-
    write('Please enter the file name (surrounded by single quotes): '),
    read(File),
    consult(File),
    assertz((traceable(_, _))).                                          % Saves traceable components.

% Makes sure the knowledge base is compatible with this shell.
legal() :-
    current_predicate(execute/1), % Checks if execute/1 exists.
    traceable(Predicate, Ports),  % Gets traceable parameters.
    nonvar(Predicate),            % Checks if the first parameter was initialized.
    nonvar(Ports).                % Checks if the second parameter was initialized.

% Knowledge base is incompatable.
legal() :-
    write('Both required predicates, execute/1 and traceable/2, were not found in the knowledge base.'),
    nl,
    fail.

% Allows for user to know when a response is needed.
prompt() :-
    nl,
    write('Please enter a command: ').

% Base case.
% Exit shell.
session(end) :-
    input(end).

% Recursive case.
% Repeatedly prompts user and executes requests.
session(Input) :-
    input(Input),
    prompt(),
    read(NewInput),
    session(NewInput).

% Solve the problem in the knowledge base.
input(solve) :-
    solve(),
    !.

% Prove the most recent solution.
input(how) :-
    retract(solved(_)),          % Remove the solution.
    traceable(Predicate, Ports), % Grab traceable components.
    trace(Predicate, Ports),     % Add a trace.
    solve(),                     % Solve the problem with the trace.
    nodebug(),                   % Exit out of trace.
    !.

% Exits shell.
input(end) :-
    write('Goodbye.'),
    nl,
    nl.

% A response could not be interpretted.
input(_) :-
    write('Invalid command.'),
    nl.

% Tries to solve problem.
solve() :-
    execute(Result),            % Searches knowledge base. This predicate is required in the knowledge base.
    not(solved(Result)),        % Makes sure the solution wasn't already found
    asserta((solved(Result))),  % Saves solution.
    write('The solution is: '),
    write(Result),
    nl.

% Problem could not be solved.
solve() :-
    write('No solution found.'),
    nl.