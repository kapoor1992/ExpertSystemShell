# ExpertSystemShell
Expert system written in Prolog.

The shell takes as input a file name for a knowledge base. The knowledge base included in "kb.pl" is for the farmer problem. The shell requires a knowledge base to have an execute/1 predicate and traceable/2 predicate in order to function. As long as execute/1 returns a goal and traceable/2 identifies parameters for the built-in trace/2 predicate, the shell is compatible.

Valid commands of the shell include:
solve
how
end
