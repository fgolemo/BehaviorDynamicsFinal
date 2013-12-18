%% var init
steps = 10;
u_i = 0.25; % this is random, I just chose 0.5 out of nowhere,
% I also tried different vales and the outcome doesn't change
u_j = [
    0.25*u_i,
    0.5*u_i,
    1*u_i,
    1.5*u_i
    ];

x_j = 0.5 % this is random, I just chose the value out of nowhere (between -1 and +1),
% I also tried different values and the outcome doesn't change

log = zeros(steps, 4, 2);


%% main loop, try 1
for i = 1:4
    u_j_current = u_j(i);
    stepping = 2*u_j_current/steps;
    
    j = 1;
    for x_i = x_j-u_j_current : stepping : x_j+u_j_current;
        overlap = min (x_i + u_i, x_j + u_j_current) - max (x_i - u_i, x_j - u_j_current);
        rel_agreement = (overlap/u_i)-1;
        
        sprintf('I:%d, J:%d\n', i, j)
        log(j,i,1) = rel_agreement;
        log(j,i,2) = x_i;
        j=j+1;
    end

end

%% draw the stuff
figure();
hold on;
title('\it{relative agreement over x_i}','FontSize',16)
xlabel('xi')
ylabel('rel. agreement')
x = 1:11;
plot (x, log(:,1,1), '-ro', x, log(:,2,1), '-.b', x, log(:,3,1), '-.g', x, log(:,4,1), '-co');
legend('0.25ui', '0.5ui', 'ui', '1.5ui');
hold off;