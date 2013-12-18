clear; clc; close all;
load('scenario 1.mat');

%% Params
iterations = 10000;
n_agents = 200;
speed = 0.5;
convergence_value = 0.5;

%% Init
agent_internal = zeros(n_agents, 2); % one for opinion, one for uncertainty
agent_internal(:,1) = EmpiricalData1(1, :, 1);
agent_internal(:,2) = rand(n_agents, 1); % set all uncertainties to 0.4

w = ones(n_agents, 5); % weights for each internal agent model
w(:,3) = rand(n_agents, 1)*2;

log = zeros(iterations, size(agent_internal,1), size(agent_internal,2)); % tracks agent change over time
log(1,:,:) = agent_internal;

T = 2; % start temperature
T_min = 0.0001; % end temperature
lambda = 0.9995; % cooling rate
steps = (T-T_min)/lambda;

errors = zeros(iterations, 1); % Used to store error values for each iteration
counter = 1;
good_opinions = agent_internal;

%% Compare calculated opinions with EmpiricalData
for i = 2:iterations % step 1 was the init, so skip it
    agent1 = f_randomAgent(n_agents, 0); % pick any random agent number
    agent2 = f_randomAgent(n_agents, agent1); % pick any random agent number, except agent1

    a1_new_opinion_uncertainty = f_talksTo(agent1, agent2, agent_internal, w(agent1,:), speed);
    a2_new_opinion_uncertainty = f_talksTo(agent2, agent1, agent_internal, w(agent2,:), speed);

    agent_internal(agent1,:,:) = a1_new_opinion_uncertainty;
    agent_internal(agent2,:,:) = a2_new_opinion_uncertainty;

    log(i,:,:) = agent_internal;
end
current_error = sum(sum(sum(EmpiricalData1(:,:,:) - log(:,:,:)).^2));
current_error = current_error + sum(sum((EmpiricalData2(:,3) - w(:,3)).^2));
errors(counter) = current_error;
counter = counter + 1;

%% MAIN LOOP
while T > T_min
    agent_internal_temp = zeros(n_agents, 2);
    w_temp = ones(n_agents, 5);
    % Change the values in a neighbour value [-0.05, 0.05]
    % min+rand(1,1)*(max-min)
    for i=1:size(agent_internal_temp,2)
        agent_internal_temp(i,2) = max(0, min(1, (agent_internal(i,2) + (rand()*0.1 - 0.1))));
    end
    for i=1:size(w_temp,3)
        w_temp(i,3) = max(0, min(1, (w(i,3) + (rand()*0.1 - 0.05))));
    end
    
    % Calculate of aggregate impacts in (time) and opinion value in (time+1)
    iterations = 10000;
    for i = 2:iterations % step 1 was the init, so skip it
    
        agent1 = f_randomAgent(n_agents, 0); % pick any random agent number
        agent2 = f_randomAgent(n_agents, agent1); % pick any random agent number, except agent1

        a1_new_opinion_uncertainty = f_talksTo(agent1, agent2, agent_internal_temp, w_temp(agent1,:), speed);
        a2_new_opinion_uncertainty = f_talksTo(agent2, agent1, agent_internal_temp, w_temp(agent2,:), speed);

        agent_internal_temp(agent1,:,:) = a1_new_opinion_uncertainty;
        agent_internal_temp(agent2,:,:) = a2_new_opinion_uncertainty;

        log(i,:,:) = agent_internal_temp;
    end
    
    %% Compare calculated opinions with EmpiricalData  
    
    new_error = sum(sum(sum(EmpiricalData1(:,:,:) - log(:,:,:)).^2));
    new_error = new_error + sum(sum((EmpiricalData2(:,3) - w_temp(:,3)).^2));
    error_delta = new_error - current_error;
    probability = rand();
    % If the found error is better than the best found until now, we store this new value
    if new_error < current_error || probability < exp(-error_delta/T) % this is new
        current_error = new_error;
        agent_internal = agent_internal_temp;
        w = w_temp;
        errors(counter) = new_error;
        good_opinions = agent_internal;
        counter = counter + 1;
    end
    counter
    T = T*lambda;
end

%% OUTPUT

figure();
hold on; 
plot (good_opinions, 'b');
plot (EmpiricalData2, 'r');
hold off; 

figure();
hold on; 
plot(errors, 'r');
hold off; 
  

 