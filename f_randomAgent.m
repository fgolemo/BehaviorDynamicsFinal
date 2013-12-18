function agentNumber = f_randomAgent(n_agents, but_not)

agentNumber = but_not;
while (agentNumber == but_not)
    agentNumber = randi(n_agents);
end

end