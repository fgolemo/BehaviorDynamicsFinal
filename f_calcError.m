function error_int = f_calcError( val_expected, val_real, step, agent1, agent2 )
%F_CALCERROR calcs the diff of EXPECTATION to REAL values in a STEP
%   TODO: Detailed explanation goes here
    

%% too easy
%     error_int = (val_expected(step,agent1,1) - val_real(step,agent1,1))^2;
%     error_int = error_int + (val_expected(step,agent2,1) - val_real(step,agent2,1))^2;

%% whole slice (one single timestep) comparison
    error_int = sum((val_expected(step,:,1) - val_real(step,:,1)).^2);

    
end

