clear; clc; close all;
load('scenario 3.mat'); % gives us EmpiricalData1 and EmpiricalData2

%% General init
steps = size(EmpiricalData1,1);

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

counter = 1;
good_opinions = log;
% errors = zeros(steps, 1);
errors(counter) = error;
counter = counter + 1;
T = 1; % start temperature
T_min = 0.01; % end temperature
lambda = 0.99; % cooling rate

%% Parameter Estimation
log_temp = zeros(steps, size(agent_internal,1), size(agent_internal,2)); % tracks agent change over time
error_delta_count = 0;
T_steps = ceil( abs( (log10(T)/log10(exp(1)) - log10(T_min)/log10(exp(1)))/(log10(lambda)/log10(exp(1)))) );
error_delta_list = zeros(T_steps,1);

tic
counter_outer = 1;
error_skip = 0;
error_tolerance_log = zeros(T_steps);
while T > T_min
    
    agent_internal_temp = zeros(n_agents, 2);
    % Change the values in a neighbour value [-0.05, 0.05]
    % min+rand(1,1)*(max-min)
    agent_internal_temp(:,1) = EmpiricalData1(1, :, 1);
    agent_internal_temp(:,2) = f_updateParameters(agent_internal, 0.1);
    
    log_temp(1,:,:) = agent_internal_temp;
    
    %% error calc (one simulation run)
    error_now = 0;
    for i = 2:steps % step 1 was the init, so skip it
        %% find out which agents communicated
        changedAgents = f_findChangedAgents(EmpiricalData1(i-1:i,:,1));
        if isempty(changedAgents) || size(changedAgents,2) == 1;
            % agents were too far apart in their opinion and therefore nothing
            % changed in this step, so go to next timestep, but log unchanged
            % data and error
            log_temp(i,:,:) = agent_internal_temp;

            % next line may be skipped/commented out for performance increase:
            %error_now = error_now + f_calcError(EmpiricalData1, log_temp, i);
            continue;
        end

        %% reproduce the conversation
        a1_new_opinion_uncertainty = f_talksTo(changedAgents(1), changedAgents(2), agent_internal_temp, w(changedAgents(1),:), speed);
        a2_new_opinion_uncertainty = f_talksTo(changedAgents(2), changedAgents(1), agent_internal_temp, w(changedAgents(2),:), speed);

        agent_internal_temp(changedAgents(1),:,:) = a1_new_opinion_uncertainty;
        agent_internal_temp(changedAgents(2),:,:) = a2_new_opinion_uncertainty;

        log_temp(i,:,:) = agent_internal_temp;
        error_now = error_now + f_calcError(EmpiricalData1, log_temp, i, changedAgents(1), changedAgents(2));
    end

    %% calc the error
    error_delta = error_now - error
    probability = rand();
    
    error_delta_list(counter_outer,1) = error_delta;
    error_delta_mean = mean(error_delta_list(1+error_skip:counter_outer))
    error_tolerance = (1/(error_delta/error_delta_mean)) * T
    error_tolerance_log(counter_outer,1) = error_tolerance;
    
    % If the found error is better than the best found until now, we store this new value
    if error_now < error || probability < (error_tolerance) % this is new
        error = error_now;
        agent_internal = agent_internal_temp;
%             w = w_temp;
        good_opinions = log_temp;
        errors(counter) = error_now;
        counter = counter + 1;
        error_skip = error_skip + 1;
    end
    %error_now
    T = T*lambda;
    %T
    counter_outer = counter_outer + 1;
end
toc

%% Print the output
figure();
hold on;
title('\it{Estimated vs Empirical Data}','FontSize',16)
xlabel('Iterations')
ylabel('Opinions')
plot (good_opinions(:,:, 1), 'b'); % only plot opinion, not uncertainty
plot (EmpiricalData1(:,:, 1), 'r'); % only plot opinion, not uncertainty
hold off;

figure();
hold on; 
plot(errors, 'r');
hold off; 

figure();
hold on; 
plot(error_tolerance_log, 'b');
hold off; 