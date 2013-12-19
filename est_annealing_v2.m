clear; clc; close all;
load('scenario 1.mat'); % gives us EmpiricalData1 and EmpiricalData2

%% General init
steps = size(EmpiricalData1,1);


%debugging
steps = 10000;



n_agents = size(EmpiricalData1,2);
speed = 0.5; % actually should be saved to input data

agent_internal = zeros(n_agents, 2); % one for opinion, one for uncertainty
w = ones(n_agents, 5); % weights for each internal agent model
w(:,3) = rand(n_agents, 1);
log = zeros(steps, size(agent_internal,1), size(agent_internal,2)); % tracks agent change over time
    
%% Scenario init (1)
agent_internal(:,2) = rand(n_agents, 1); % set all uncertainties to 0.4
agent_internal(:,1) = EmpiricalData1(1,:,1); % random opinions from -1 to +1

%% Main loop
log(1,:,:) = agent_internal;
error = 0;
times = zeros(steps-1,6);

tic
for i = 2:steps % step 1 was the init, so skip it
    
    %% find out which agents communicated
    changedAgents = f_findChangedAgents(EmpiricalData1(i-1:i,:,1));
    if isempty(changedAgents) || size(changedAgents,2) == 1;
        % agents were too far apart in their opinion and therefore nothing
        % changed in this step, so go to next timestep, but log unchanged
        % data and error
        log(i,:,:) = agent_internal;

        % next line may be skipped/commented out for performance increase:
        error = error + f_calcError(EmpiricalData1, log, i);
        continue;
    end
    
    %% reproduce the conversation
    a1_new_opinion_uncertainty = f_talksTo(changedAgents(1), changedAgents(2), agent_internal, w(changedAgents(1),:), speed);
    a2_new_opinion_uncertainty = f_talksTo(changedAgents(2), changedAgents(1), agent_internal, w(changedAgents(2),:), speed);
    
    agent_internal(changedAgents(1),:,:) = a1_new_opinion_uncertainty;
    agent_internal(changedAgents(2),:,:) = a2_new_opinion_uncertainty;
    
    log(i,:,:) = agent_internal;
    
    %% calc the error
    % agent parameters no longer used but kept here for illustration:
    error = error + f_calcError(EmpiricalData1, log, i, changedAgents(1), changedAgents(2));

end
toc

