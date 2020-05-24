function [] = plotData (Name,pop,cases,deaths,recovered)
%--------------------------------------------------------------------------
% plotData.m
% 
% Description: This function plots the data from the covid19 project on a 
% logarithmic plot. The data is presented as a function of the total
% country's population.
%
% Author: Isaac Weintraub
%--------------------------------------------------------------------------
figure;
hold on
H1=area(0:120,1*ones(size(0:120)),'FaceColor',[1 0 0],...
    'FaceAlpha',0.6,'EdgeColor','none');
H1=area(0:120,0.1*ones(size(0:120)),'FaceColor',[1 1 1],...
    'FaceAlpha',0.2,'EdgeColor','none');
H1=area(0:120,.01*ones(size(0:120)),'FaceColor',[1 1 1],...
    'FaceAlpha',0.2,'EdgeColor','none');
H1=area(0:120,0.001*ones(size(0:120)),'FaceColor',[1 1 1],...
    'FaceAlpha',0.2,'EdgeColor','none');
H1=area(0:120,0.0001*ones(size(0:120)),'FaceColor',[1 1 1],...
    'FaceAlpha',0.2,'EdgeColor','none');
H1=area(0:120,0.00001*ones(size(0:120)),'FaceColor',[1 1 1],...
    'FaceAlpha',0.2,'EdgeColor','none');
H1=area(0:120,0.000001*ones(size(0:120)),'FaceColor',[1 1 1],...
    'FaceAlpha',0.2,'EdgeColor','none');
H1=area(0:120,0.0000001*ones(size(0:120)),'FaceColor',[1 1 1],...
    'FaceAlpha',0.2,'EdgeColor','none');
text(2.5,1,['120% Pop: ' num2str(pop)])
text(2.5,0.16,['10% Pop: ' num2str(floor(0.1*pop))])
text(2.5,0.016,['1% Pop: ' num2str(floor(0.01*pop))])
text(2.5,0.0016,['0.1% Pop: ' num2str(floor(0.001*pop))])
text(2.5,0.00016,['0.01% Pop: ' num2str(floor(0.0001*pop))])
text(length(cases)+3,cases(end)./pop,['Cases: ' num2str(cases(end))])
text(length(deaths)+3,deaths(end)./pop,['Deaths: ' num2str(deaths(end))])
p1 = semilogy(cases./pop,'ko','DisplayName',[Name ' Confirmed Cases'],'MarkerSize',8);
p2 = semilogy(deaths./pop,'ks','DisplayName',[Name ' Confirmed Deaths'],'MarkerSize',8);
p3 = semilogy(recovered./pop,'kp','DisplayName',[Name ' Confirmed Recovery'],'MarkerSize',10);
ffig = gcf;
ffig.Children.YScale = 'log';
legend([p1 p2 p3],'location','NorthEast')
xlim([0 120])
ylim([1e-8,1])
grid on
title(Name)
ylabel('Fraction of total Population')
xlabel('Days Since Jan 22 2020')
end