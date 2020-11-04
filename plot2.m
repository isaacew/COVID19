function [fig1, fig2, fig3, fig4] = plot2(Name,pop,cases,deaths,recovered,plotType)
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

if Dcases(end) == max(Dcases)
   fprintf('%s is growing at its maximum rate \n',Name) 
end
    
[maxRate,indexMaxRate] = max(Dcases);
indexNegAcc = find(DDcases<0, 1, 'first');
firstNegAcc = DDcases(indexNegAcc);
dateVector = 22+[1:length(cases)];
numDays = dateVector(end)-22;
fig1 = figure;
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
ffig.Children.YScale = 'log';
legend([p1 p2 p3],'location','NorthEast')
ylim([1e-8,1])
grid on
title(Name)
ylabel('Fraction of total Population')
xlabel('Date')
else
ffig = gcf;
ffig.Children.YScale = 'log';
legend([p1 p2],'location','NorthEast')
ylim([1e-8,1])
grid on
title(Name)
ylabel('Fraction of total Population')
xlabel('Date')
end
datetick('x','mmm')
xlim([0 numDays+60])

saveas(fig1,["Figures/"+plotType+"/"+Name+"_Cases.png"]);

% figure;
% hold on
% p1 = semilogy(cases,'ko','DisplayName',[Name ' Confirmed Cases'],'MarkerSize',8);
% p2 = semilogy(deaths,'ks','DisplayName',[Name ' Confirmed Deaths'],'MarkerSize',8);
% if ~isempty(recovered)
%     p3 = semilogy(recovered,'kp','DisplayName',[Name ' Confirmed Recovery'],'MarkerSize',10);
%     ffig = gcf;
%     ffig.Children.YScale = 'linear';
%     legend([p1 p2 p3],'location','NorthEast');
%     xlim([0 numDays])
%     grid on
%     title(Name);
%     ylabel('Number of Confirmed Cases');
%     xlabel('Days Since Jan 22 2020');
% else
%     ffig = gcf;
%     ffig.Children.YScale = 'linear';
%     legend([p1 p2],'location','NorthEast');
%     xlim([0 numDays])
%     grid on
%     title(Name)
%     ylabel('Number of Confirmed Cases');
%    xlabel('Days Since Jan 22 2020')
% end

% %%% ANIMATION %%%
% fig3 = figure;
% hold on
% xlim([min(cases) max(cases)]);
% ylim([min(Dcases) max(Dcases)]);
% ylabel('Rate Change of Cases');
% xlabel('Number of Confirmed Cases');
% title(Name)
% h = animatedline('Color','k','Marker','o','MarkerSize',10,'DisplayName',[Name ' Confirmed Cases']);
% filename = ['Figures/'+plotType+'/'+Name+'_CasesPhase.gif'];
% fname = convertStringsToChars(filename);
% % Need to write out
% [A,map] = rgb2ind(frame2im(getframe),256);
% imwrite(A,map,fname,'LoopCount',inf);
% 
% for k = 1:length(cases) 
%   addpoints(h,cases(k),Dcases(k))  
%   drawnow  
%   % Capture the plot as an image 
%   [A,map] = rgb2ind(frame2im(getframe),256);
%   imwrite(A,map,fname,'gif','WriteMode','append'); 
% end
% %%% ANIMATION %%%

fig3 = figure;
hold on
plot(cases,Dcases,'k-o','DisplayName',[Name ' Confirmed Cases'],'MarkerSize',8);
plot(cases(indexMaxRate),Dcases(indexMaxRate),'r*','MarkerSize',10,'DisplayName','Maximum Rate')

legend([p1],'location','NorthWest');
grid on
fig3.Children.XScale = 'linear';
fig3.Children.YScale = 'linear';
title(Name)
ylabel('Rate Change of Cases');
xlabel('Number of Confirmed Cases');
saveas(fig3,["Figures/"+plotType+"/"+Name+"_CasesPhase.png"]);


fig4 = figure;
hold on
plot(Dcases,DDcases,'-','DisplayName',[Name ' Confirmed Cases'],'MarkerSize',8);
if ~isempty(indexMaxRate)
    plot(Dcases(indexMaxRate),DDcases(indexMaxRate),'r*','MarkerSize',10,'DisplayName','Maximum Rate')
end
if ~isempty(indexNegAcc)
    plot(Dcases(indexNegAcc),DDcases(indexNegAcc),'b*','MarkerSize',10,'DisplayName','Maximum Rate')
end
legend([p1],'location','NorthWest');
grid on
fig4.Children.XScale = 'linear';
fig4.Children.YScale = 'linear';
title(Name)
ylabel('Acceleration of Confirmed Cases');
xlabel('Rate of Confirmed Cases');
saveas(fig4,["Figures/"+plotType+"/"+Name+"_CasesPhaseRate.png"]);

% % h = animatedline('Color','b','LineWidth',3,...
% %     'DisplayName',[Name ' Confirmed Cases'],...
% %     'MaximumNumPoints',10);
% % filename = ['Figures/'+plotType+'/'+Name+'_CasesPhaseRate.gif'];
% % fname = convertStringsToChars(filename);
% % % Need to write out
% % [A,map] = rgb2ind(frame2im(getframe),256);
% % imwrite(A,map,fname,'LoopCount',inf);
% % for k = 1:length(Dcases) 
% %   addpoints(h,Dcases(k),DDcases(k))  
% %   drawnow  
% %   % Capture the plot as an image 
% %   [A,map] = rgb2ind(frame2im(getframe),256);
% %   imwrite(A,map,fname,'gif','WriteMode','append'); 
% % end


fig5 = figure();
hold on
p1 = plot(deaths,Ddeaths,'-s','DisplayName',[Name ' Confirmed Deaths'],'MarkerSize',8);
legend([p1],'location','NorthWest');
grid on
title(Name)
ylabel('Rate of Confirmed Deaths');
xlabel('Numer of Confirmed Deaths');
saveas(fig5,["Figures/"+plotType+"/"+Name+"_DeathPhase.png"]);

fig6 = figure();
hold on
p1 = plot(Ddeaths,DDdeaths,'-s','DisplayName',[Name ' Confirmed Deaths'],'MarkerSize',8);
legend([p1],'location','NorthWest');
grid on
title(Name)
ylabel('Acceleration of Confirmed Deaths');
xlabel('Rate of Confirmed Deaths');
saveas(fig6,["Figures/"+plotType+"/"+Name+"_DeathPhaseRate.png"]);

if length(cases)==length(recovered) && length(deaths)==length(cases)
fig7 = figure();
plot(dateVector,(cases-recovered-deaths)/pop,'b-','LineWidth',3);
%plot(cases-deaths,'r-x','LineWidth',3); hold on
text(2.5,1,['100% Pop: ' num2str(pop)])
text(2.5,0.1,['10% Pop: ' num2str(floor(0.1*pop))])
text(2.5,0.01,['1% Pop: ' num2str(floor(0.01*pop))])
text(2.5,0.001,['0.1% Pop: ' num2str(floor(0.001*pop))])
text(2.5,0.0001,['0.01% Pop: ' num2str(floor(0.0001*pop))])
text(numDays(end)+25,(cases(end)-recovered(end)-deaths(end))/pop,['Active: ' num2str((cases(end)-recovered(end)-deaths(end)))])

legend('Active Cases','Location','NorthWest')
title(Name)
grid on
ylabel('Active Cases as a Fraction of total Population')
xlabel('Date')
% ylim([1e-8,1])
datetick('x','mmm')
xlim([0 numDays+60])
saveas(fig7,["Figures/"+plotType+"/"+Name+"_ActiveCases.png"]);
end


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