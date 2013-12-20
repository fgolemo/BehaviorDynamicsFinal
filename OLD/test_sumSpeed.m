a=2; N1=3; N2=3;
A=ceil(10*rand(a*N1,a*N2))

% Engine
AA = reshape(A,[a N1 a N2])
AA = permute(AA,[2 4 1 3])
AA = reshape(AA, [N1 N2 a*a])
B = sum(AA,3)