function [fig1, fig2, fig3, fig4] = plot21(Name,pop,cases,deaths,recovered,plotType,plotFlag)
%--------------------------------------------------------------------------
% plot2.m
% 
% Description: This function plots the data from the covid19 project on a 
% logarithmic plot. The data is presented as a function of the total
% country's population.
%
% Author: Isaac Weintraub
%--------------------------------------------------------------------------
if length(deaths)~=length(cases)
    minL = min([length(deaths) length(cases)]);
    deaths = deaths(1:minL);
    cases  = cases(1:minL);
end

Dcases = filter(-smooth_diff(10),1,cases);
Ddeaths = filter(-smooth_diff(10),1,deaths);
DDcases = filter(-smooth_diff(10),1,Dcases);
DDdeaths = filter(-smooth_diff(10),1,Ddeaths);

if plotFlag    
[maxRate,indexMaxRate] = max(Dcases);
indexNegAcc = find(DDcases<0, 1, 'first');
firstNegAcc = DDcases(indexNegAcc);
dateVector = 22+[1:length(cases)];
numDays = dateVector(end)-22;
fig1 = figure;
subplot(2,2,1:2)
hold on
H1=area(0:numDays+60,1*ones(size(0:numDays+60)),'FaceColor',[1 0 0],...
    'FaceAlpha',0.6,'EdgeColor','none');
H1=area(0:numDays+60,0.1*ones(size(0:numDays+60)),'FaceColor',[1 1 1],...
    'FaceAlpha',0.2,'EdgeColor','none');
H1=area(0:numDays+60,.01*ones(size(0:numDays+60)),'FaceColor',[1 1 1],...
    'FaceAlpha',0.2,'EdgeColor','none');
H1=area(0:numDays+60,0.001*ones(size(0:numDays+60)),'FaceColor',[1 1 1],...
    'FaceAlpha',0.2,'EdgeColor','none');
H1=area(0:numDays+60,0.0001*ones(size(0:numDays+60)),'FaceColor',[1 1 1],...
    'FaceAlpha',0.2,'EdgeColor','none');
H1=area(0:numDays+60,0.00001*ones(size(0:numDays+60)),'FaceColor',[1 1 1],...
    'FaceAlpha',0.2,'EdgeColor','none');
H1=area(0:numDays+60,0.000001*ones(size(0:numDays+60)),'FaceColor',[1 1 1],...
    'FaceAlpha',0.2,'EdgeColor','none');
H1=area(0:numDays+60,0.0000001*ones(size(0:numDays+60)),'FaceColor',[1 1 1],...
    'FaceAlpha',0.2,'EdgeColor','none');
text(2.5,1,['100% Pop: ' num2str(pop)])
text(2.5,0.16,['10% Pop: ' num2str(floor(0.1*pop))])
text(2.5,0.016,['1% Pop: ' num2str(floor(0.01*pop))])
text(2.5,0.0016,['0.1% Pop: ' num2str(floor(0.001*pop))])
text(2.5,0.00016,['0.01% Pop: ' num2str(floor(0.0001*pop))])
text(dateVector(end)+3,cases(end)./pop,['Cases: ' num2str(cases(end))])
text(dateVector(end)+3,deaths(end)./pop,['Deaths: ' num2str(deaths(end))])
p1 = semilogy(dateVector(1:3:end),cases(1:3:end)./pop,'ko','DisplayName',[Name ' Confirmed Cases'],'MarkerSize',8);

p2 = semilogy(dateVector(1:3:end),deaths(1:3:end)./pop,'ks','DisplayName',[Name ' Confirmed Deaths'],'MarkerSize',8);
if ~isempty(recovered)
    p3 = semilogy(dateVector(1:3:end),recovered(1:3:end)./pop,'kp','DisplayName',[Name ' Confirmed Recovery'],'MarkerSize',10);
if ~isempty(indexMaxRate)
    %semilogy(indexMaxRate,cases(indexMaxRate)./pop,'r*','MarkerSize',10);
end
if ~isempty(indexNegAcc)
    %semilogy(indexNegAcc,cases(indexNegAcc)./pop,'b*','MarkerSize',10);
end
ffig = gcf;
ffig.Children(end).YScale = 'log';
legend([p1 p2 p3],'location','SouthEast')
ylim([1e-8,1])
grid on
title(Name)
ylabel('Fraction of total Population')
xlabel('Date')
else
ffig = gcf;
ffig.Children(end).YScale = 'log';
legend([p1 p2],'location','SouthEast')
ylim([1e-8,1])
grid on
title(Name)
ylabel('Fraction of total Population')
xlabel('Date')
end
datetick('x','mmm')
xlim([0 numDays+60])


subplot(2,2,3)
hold on
plot(cases,Dcases,'k-o','DisplayName',[Name ' Confirmed Cases'],'MarkerSize',8);
plot(cases(indexMaxRate),Dcases(indexMaxRate),'r*','MarkerSize',10,'DisplayName','Maximum Rate')

legend([p1],'location','SouthEast');
grid on
% fig3.Children(end).XScale = 'linear';
% fig3.Children(end).YScale = 'linear';
title(Name)
ylabel('Rate Change of Cases');
xlabel('Number of Confirmed Cases');
% saveas(fig3,["Figures/"+plotType+"/"+Name+"_CasesPhase.png"]);

subplot(2,2,4)
hold on
plot(Dcases,DDcases,'-o','DisplayName',[Name ' Confirmed Cases'],'MarkerSize',8);
if ~isempty(indexMaxRate)
    plot(Dcases(indexMaxRate),DDcases(indexMaxRate),'r*','MarkerSize',10,'DisplayName','Maximum Rate')
end
if ~isempty(indexNegAcc)
    plot(Dcases(indexNegAcc),DDcases(indexNegAcc),'b*','MarkerSize',10,'DisplayName','Maximum Rate')
end
legend([p1],'location','SouthEast');
grid on
% fig4.Children(end).XScale = 'linear';
% fig4.Children(end).YScale = 'linear';
title(Name)
ylabel('Acceleration of Confirmed Cases');
xlabel('Rate of Confirmed Cases');
saveas(gcf,["Figures/"+plotType+"/"+Name+"_Information.png"]);

% if length(cases)==length(recovered) && length(deaths)==length(cases)
% subfigure(2,2,4)
% plot(dateVector,(cases-recovered-deaths)/pop,'b-','LineWidth',3);
% %plot(cases-deaths,'r-x','LineWidth',3); hold on
% text(2.5,1,['100% Pop: ' num2str(pop)])
% text(2.5,0.1,['10% Pop: ' num2str(floor(0.1*pop))])
% text(2.5,0.01,['1% Pop: ' num2str(floor(0.01*pop))])
% text(2.5,0.001,['0.1% Pop: ' num2str(floor(0.001*pop))])
% text(2.5,0.0001,['0.01% Pop: ' num2str(floor(0.0001*pop))])
% text(numDays(end)+25,(cases(end)-recovered(end)-deaths(end))/pop,['Active: ' num2str((cases(end)-recovered(end)-deaths(end)))])
% 
% legend('Active Cases','Location','NorthWest')
% title(Name)
% grid on
% ylabel('Active Cases as a Fraction of total Population')
% xlabel('Date')
% % ylim([1e-8,1])
% datetick('x','mmm')
% xlim([0 numDays+60])
% % saveas(fig7,["Figures/"+plotType+"/"+Name+"_ActiveCases.png"]);
% end
% % % saveas(fig1,["Figures/"+plotType+"/"+Name+"_Cases.png"]);



% fig4 = figure;
% hold on
% H1=area(0:numDays,1*ones(size(0:numDays)),'FaceColor',[1 0 0],...
%     'FaceAlpha',0.6,'EdgeColor','none');
% H1=area(0:numDays,0.1*ones(size(0:numDays)),'FaceColor',[1 1 1],...
%     'FaceAlpha',0.2,'EdgeColor','none');
% H1=area(0:numDays,.01*ones(size(0:numDays)),'FaceColor',[1 1 1],...
%     'FaceAlpha',0.2,'EdgeColor','none');
% H1=area(0:numDays,0.001*ones(size(0:numDays)),'FaceColor',[1 1 1],...
%     'FaceAlpha',0.2,'EdgeColor','none');
% H1=area(0:numDays,0.0001*ones(size(0:numDays)),'FaceColor',[1 1 1],...
%     'FaceAlpha',0.2,'EdgeColor','none');
% H1=area(0:numDays,0.00001*ones(size(0:numDays)),'FaceColor',[1 1 1],...
%     'FaceAlpha',0.2,'EdgeColor','none');
% H1=area(0:numDays,0.000001*ones(size(0:numDays)),'FaceColor',[1 1 1],...
%     'FaceAlpha',0.2,'EdgeColor','none');
% H1=area(0:numDays,0.0000001*ones(size(0:numDays)),'FaceColor',[1 1 1],...
%     'FaceAlpha',0.2,'EdgeColor','none');
% text(2.5,1,['numDays% Pop: ' num2str(pop)])
% text(2.5,0.16,['10% Pop: ' num2str(floor(0.1*pop))])
% text(2.5,0.016,['1% Pop: ' num2str(floor(0.01*pop))])
% text(2.5,0.0016,['0.1% Pop: ' num2str(floor(0.001*pop))])
% text(2.5,0.00016,['0.01% Pop: ' num2str(floor(0.0001*pop))])
% text(length(cases)+3,cases(end)./pop,['Cases: ' num2str(cases(end))])
% text(length(deaths)+3,deaths(end)./pop,['Deaths: ' num2str(deaths(end))])
% p1 = semilogy(cases./pop - recovered./pop,'ko','DisplayName',[Name ' Active Cases'],'MarkerSize',8);
% p2 = semilogy(deaths./pop,'ks','DisplayName',[Name ' Confirmed Deaths'],'MarkerSize',8);
% if ~isempty(recovered)
% ffig = gcf;
% ffig.Children.YScale = 'log';
% legend([p1 p2 p3],'location','NorthEast')
% xlim([0 numDays])
% ylim([1e-8,1])
% grid on
% title(Name)
% ylabel('Fraction of total Population')
% xlabel('Days Since Jan 22 2020')
% else
% ffig = gcf;
% ffig.Children.YScale = 'log';
% legend([p1 p2],'location','NorthEast')
% xlim([0 numDays])
% ylim([1e-8,1])
% grid on
% title(Name)
% ylabel('Fraction of total Population')
% xlabel('Days Since Jan 22 2020')
% end
% saveas(fig4,["StateFigures/"+Name+"_ActiveCases.png"])
end
end