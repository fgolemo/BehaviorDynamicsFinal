function updated = f_updateParameters( parameters, range )
    updated = zeros(size(parameters,1), 1);
    for i = 1 : size(parameters,1)
        updated(i,1) = max(0, min(1, (parameters(i,2) + (rand()*(range*2) - range))));
    end
    
end

