function J = myfun(X,casesCountry,popCountry)

initDay = 40;
% Guess for parameters
gamma = X(1);
beta  = X(2);
dayMax = length(casesCountry);
% Initial Conditions
S0 = popCountry-casesCountry(initDay);
I0 = casesCountry(initDay);%0.9e-3;
R0 = 0;
X0 = [S0;I0;R0];

% Regression Fit of the SIR Model to the COVID19 Outbreak
days = 1:2*length(casesCountry);

% Ode45
tspan = [initDay days(end)-1]; % time vector
[TOUT,YOUT] = ode45(@(t,X)SIR(t,X,gamma,beta),tspan,X0);
I_indexed = interp1(TOUT,YOUT(:,2),initDay:dayMax); % Line up model with data

% Plot the Data
% close all
 f99 = figure(99); clf;
 plot(TOUT,YOUT,'LineWidth',3)
 hold on
 plot(1:length(casesCountry),casesCountry,'ko','MarkerSize',10)
 plot(initDay:length(casesCountry),I_indexed,'bx','MarkerSize',10)
 f99.Children.YScale = 'log';
 %ylim([0 3e5])
 xlim([0 max(days)])
 drawnow
 title('United States')
 disp(gamma)
 disp(beta)
 legend('Susceptible','Infections','Recovered','CDC Data','Model Evaluation')
 xlabel('Days Since 22 Jan 2020')
 ylabel('Number of People')
% % Generate Error


error = abs(I_indexed-casesCountry(initDay:end));
J = sum(error);

end


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
