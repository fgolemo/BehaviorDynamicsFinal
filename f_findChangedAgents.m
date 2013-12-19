function changedAgents = f_findChangedAgents(input)
%F_FINDCHANGEDAGENTS returns indices of changes in the matrix
%   finds the two agents that have changed their opinions between the two timeslices

    changedAgents = find(diff(input));


end

