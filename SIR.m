function [dX] = SIR(t,X,gamma,beta)
% SIR MODEL
% SOURCE - WIKIPEDIA
% CODE AUTHOR - ISAAC WEINTRAUB
%==========================================
% Takes in a state of S I R and outputs the Derivative
%
% dS/dt = -beta * I * S / N;
% dI/dt = beta * I * S / N - gamma*I;
% dR/dt = gamma * I;
% N = S + I + R
%==========================================
% Gather the states of the system
S = X(1); 
I = X(2); 
R = X(3);
% Compute variabels in the equaitons
N = S + I + R;
% Compute the derivatives
DS = -beta*I*S/N;
DI = beta*I*S/N-gamma*I;
DR = gamma*I;
dX = [DS;DI;DR];
end

