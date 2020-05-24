function [c,ceq] = nonlcon(t,X)
% Guess for parameters
gamma = X(1);
beta  = X(2);
ceq = [];
c = [gamma beta]';
end
