
% agentA: the agent that is influenced (whose model should be updated); in
%   the paper "j"
% agentB: the conversation partner, supplying incoming opinion and
%   uncertainty; in the paper "i"
function new_opinion_uncertainty = f_talksTo(agentA, agentB, agent_internal, w, speed)

% w1: weight of incoming opinion
% w2: weight of incoming uncertainty
% w3: weight of overlap
% w4: weight of outgoing opinion
% w5: weight of outgoing uncertainty

op_ext_in = w(1) * agent_internal(agentB, 1); % opinion, external, incoming
un_ext_in = w(2) * agent_internal(agentB, 2); % uncertainty, external, incoming

op_int = agent_internal(agentA, 1); % opinion, internal (before communication with agentB)
un_int = agent_internal(agentA, 2); % uncertainty, internal (before communication)

% OLD
% overlap: noted as h_ij in the paper
% overlap = min(op_ext_in + un_ext_in, op_int + un_int) - max(op_ext_in - un_ext_in, op_int - un_int);
% relative_agreement = ((overlap * w(3))/un_ext_in) - 1;
% op_int = op_int + speed * relative_agreement * (op_ext_in - op_int);
% un_int = un_int + speed * relative_agreement * (un_ext_in - un_int);

%% wrong
% ext_in_max = min(op_ext_in + un_ext_in, 1);
% int_max = min(op_int + un_int, 1);
% ext_in_min = max(op_ext_in - un_ext_in, -1);
% int_min = max(op_int - un_int, -1);

%% better
ext_in_max = op_ext_in + un_ext_in;
int_max = op_int + un_int;
ext_in_min = op_ext_in - un_ext_in;
int_min = op_int - un_int;

%% TODO: verify
overlap = min(ext_in_max, int_max) - max(ext_in_min, int_min); % noted as h_ij in the paper
overlap = max(0,min(2,overlap)); % make sure to keep boundaries
relative_agreement = ((overlap * w(3))/un_ext_in) - 1;
relative_agreement = max(0,min(1,relative_agreement)); % make sure to keep boundaries

op_int = op_int + speed * relative_agreement * (op_ext_in - op_int);
un_int = un_int + speed * relative_agreement *  (un_ext_in - un_int);

% make sure to keep boundaries
op_int = max(-1,min(1,op_int));
un_int = max(-1,min(1,un_int));

new_opinion_uncertainty = [
    w(4)*op_int, w(5)*un_int
];

end