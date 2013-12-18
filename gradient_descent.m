clear; clc; close all;
load('scenario 1.mat');

%% Params
steps = 10000;
n_agents = 200;
speed = 0.5;
convergence_value = 0.5;
counter = 1;

%% Init
agent_internal = zeros(n_agents, 2); % one for opinion, one for uncertainty
agent_internal(:,1) = EmpiricalData1(1, :, 1);
agent_internal(:,2) = rand(n_agents, 1); % set all uncertainties to 0.4

w = ones(n_agents, 5); % weights for each internal agent model
w(:,3) = rand(n_agents, 1)*2;

log = zeros(steps, size(agent_internal,1), size(agent_internal,2)); % tracks agent change over time
log(1,:,:) = agent_internal;

%% Compare calculated opinions with EmpiricalData
current_error = sum(sum((EmpiricalData1(1,:,:) - log(1,:,:)).^2));
current_error = current_error + sum(sum((EmpiricalData2(:,3) - w(:,3)).^2));
errors(counter) = current_error;
counter = counter + 1;
%% Calculate of aggregate impacts in (time) and opinion value in (time+1)
% for i = 2:steps % step 1 was the init, so skip it
%     
%     agent1 = f_randomAgent(n_agents, 0); % pick any random agent number
%     agent2 = f_randomAgent(n_agents, agent1); % pick any random agent number, except agent1
%     
%     a1_new_opinion_uncertainty = f_talksTo(agent1, agent2, agent_internal, w(agent1,:), speed);
%     a2_new_opinion_uncertainty = f_talksTo(agent2, agent1, agent_internal, w(agent2,:), speed);
%     
%     agent_internal(agent1,:,:) = a1_new_opinion_uncertainty;
%     agent_internal(agent2,:,:) = a2_new_opinion_uncertainty;
%     
%     log(i,:,:) = agent_internal;
% end

% 
% Change the values in a neighbour value [-0.05, 0.05]
% min+rand(1,1)*(max-min)

%% main loop
temp=0;
old_error = 999;
delta = 1;
min_changes = 0.01;
while abs(delta) > min_changes
%    
%     %% Calculate sensitivity - iterate over each connection
%     for i=1:size(connections,1)
%         for j=1:size(connections,2)
%             if connections(i,j) ~= 0
%                 connection_strength_temp = connection_strengths;
%                 connection_strength_temp(i,j) = max(0, min(1, connection_strengths(i,j) + parameter_step));
%                 opinions_temp = zeros(size(EmpiricalData2));
%                 opinions_temp(1,:) = opinions(1, :);
%                 aggregate_impact = zeros(size(EmpiricalData2, 1), number_agents);
%                 for time=start_time:size(EmpiricalData2, 1)-1
%                     %% iterate over all parameters (agents)
%                     for k=1:number_agents
%                         for l=1:number_agents
%                             if k~=l
%                                 aggregate_impact(time, k) = aggregate_impact(time, k) + (connection_strength_temp(l, k) * opinions_temp(time, l))/sum(connection_strength_temp(:, k));
%                             end
%                         end
%                         opinions_temp(time+1,k) = max(0, min(1, (opinions_temp(time, k) + convergence_value*(aggregate_impact(time,k) - opinions_temp(time, k)))));
%                     end
%                 end
%                 %% Compare calculated opinions with EmpiricalData
%                 error_after = sum(sum((EmpiricalData2(:,:) - opinions_temp(:, :)).^2));
%                 sensitivity(i,j) = (error_after-current_error)/parameter_step;
%             end
%         end
%     end
%     %% Update values of parameters
%     for i=1:size(connection_strengths,1)
%         for j=1:size(connection_strengths,2)
%             connection_strengths(i,j) = max(0, min(1, (connection_strengths(i,j) - adjustament_rate*sensitivity(i,j))));
%         end
%     end
%     
%     %% Calc new error with new paramters
%     aggregate_impact = zeros(size(EmpiricalData2, 1), number_agents);
%     for time=start_time:size(EmpiricalData2, 1)-1
%         for i=1:number_agents
%             for j=1:number_agents
%                 if i~=j
%                     aggregate_impact(time, i) = aggregate_impact(time, i) + (connection_strengths(j, i) * opinions(time, j))/sum(connection_strengths(:, i));
%                 end
%             end
%             opinions(time+1, i) = max(0, min(1, opinions(time, i) + convergence_value*(aggregate_impact(time, i) - opinions(time, i))));
%         end
%     end
%     
%     current_error = sum(sum((EmpiricalData2(:,:) - opinions(:, :)).^2));
%     delta = old_error - current_error;
%     old_error = current_error;
%    
%     % If the found error is better than the best found until now, we store this new value
%     errors(counter) = current_error;
%     
%     counter = counter+1;
end

%% Draw the history
figure();
hold on;
title('\it{Estimated vs Empirical Data}','FontSize',16)
xlabel('Iterations')
ylabel('Opinions')
plot (log(:,:, 1), 'b'); % only plot opinion, not uncertainty
plot (EmpiricalData1(:,:, 1), 'r'); % only plot opinion, not uncertainty
hold off;
 