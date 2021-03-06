clear; clc; close all;

%% Params
steps = 10000;
n_agents = 200;
speed = 0.5;

%% Init
agent_internal = zeros(n_agents, 2); % one for opinion, one for uncertainty
w = ones(n_agents, 5); % weights for each internal agent model
% w(:,1) = rand(n_agents, 1)/2+0.5;
% w(:,2) = rand(n_agents, 1)/2+0.5;
% w(:,3) = rand(n_agents, 1)/4+0.75;
% w(:,4) = rand(n_agents, 1)/2+0.5;
% w(:,5) = rand(n_agents, 1)/2+0.5;
log = zeros(steps, size(agent_internal,1), size(agent_internal,2)); % tracks agent change over time
    
%% Scenario init (1)
% agent_internal(:,2) = rand(n_agents, 1)/3+0.33; % set all uncertainties to 0.4
% agent_internal(:,1) = rand(1,n_agents)*2-1; % random opinions from -1 to +1

%% Scenario init (2)
% n_extremists = 20;
% extremist_uncertainty = 0.1;
% 
% agent_internal(:,2) = rand(n_agents, 1)/3+0.5; % set all uncertainties to 0.6
% agent_internal(:,1) = rand(1,n_agents)*2-1; % random opinions from -1 to +1
% agent_internal(1:n_extremists,1) = 1; % N positive extremists
% agent_internal(1+n_extremists:2*n_extremists,1) = -1; % N negative extremists
% agent_internal(1:2*n_extremists,2) = extremist_uncertainty; % set their uncertainty

%% Scenario init (3)
n_extremists = 20;
extremist_uncertainty = 0.1;

agent_internal(:,2) = rand(n_agents, 1)/2+1; % set all uncertainties to 1.2
agent_internal(:,1) = rand(1,n_agents)*2-1; % random opinions from -1 to +1
agent_internal(1:n_extremists,1) = 1; % N positive extremists
agent_internal(1+n_extremists:2*n_extremists,1) = -1; % N negative extremists
agent_internal(1:2*n_extremists,2) = extremist_uncertainty; % set their uncertainty

%% Scenario init (4)
% n_extremists_pos = 5;
% n_extremists_neg = 5;
% extremist_uncertainty = 0.1;
% 
% agent_internal(:,2) = rand(n_agents, 1)/4+1.3; % set all uncertainties to 1.4
% agent_internal(:,1) = rand(1,n_agents)*2-1; % random opinions from -1 to +1
% agent_internal(1:n_extremists_pos,1) = 1; % N positive extremists
% agent_internal(1+n_extremists_pos:n_extremists_pos+n_extremists_neg,1) = -1; % N negative extremists
% agent_internal(1:n_extremists_pos+n_extremists_neg,2) = extremist_uncertainty; % set their uncertainty

%% Main loop
log(1,:,:) = agent_internal;
for i = 2:steps % step 1 was the init, so skip it
    agent1 = f_randomAgent(n_agents, 0); % pick any random agent number
    agent2 = f_randomAgent(n_agents, agent1); % pick any random agent number, except agent1
    
    a1_new_opinion_uncertainty = f_talksTo(agent1, agent2, agent_internal, w(agent1,:), speed);
    a2_new_opinion_uncertainty = f_talksTo(agent2, agent1, agent_internal, w(agent2,:), speed);
    
    agent_internal(agent1,:,:) = a1_new_opinion_uncertainty;
    agent_internal(agent2,:,:) = a2_new_opinion_uncertainty;
    
    log(i,:,:) = agent_internal;
end

%% Count extremist now
cont_pos = 0;
cont_neg = 0;
for i=1:n_agents
    if log(steps,i,1) > 0.6
        cont_pos = cont_pos + 1;
    end
    if log(steps,i,1) < -0.6
        cont_neg = cont_neg + 1;
    end
end
cont_pos
cont_neg

%% Draw the history
figure();
hold on;
title('\it{Opinion values over the time}','FontSize',16)
xlabel('Iterations')
ylabel('Opinions')
plot (log(:,:, 1)); % only plot opinion, not uncertainty
hold off;