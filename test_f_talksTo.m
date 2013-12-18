steps = 10;
u_i = 0.5;
u_j = [
    0.25*u_i,
    0.5*u_i,
    1*u_i,
    1.5*u_i
    ];

x_j = 0.5

log = zeros(steps, 4);

for j = 1:4
    u_j_current = u_j(i);
    stepping = 2*u_j_current/steps;
    
    for x_i = x_j-u_j_current : x_j+u_j_current : steps;
        overlap = min (x_i + u_i, x_j + u_j_current) - max (x_i - u_i, x_j - u_j_current)
    end

end