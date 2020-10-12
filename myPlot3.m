function [fig1, fig2, fig3, fig4] = myPlot3(Name,pop,cases,deaths,recovered,plotType)


Dcases = filter(-smooth_diff(10),1,cases);
Ddeaths = filter(-smooth_diff(10),1,deaths);
DDcases = filter(-smooth_diff(10),1,Dcases);
DDdeaths = filter(-smooth_diff(10),1,Ddeaths);

hold on

[maxRate,indexMaxRate] = max(Dcases);
indexNegAcc = find(DDcases<0, 1, 'first');
firstNegAcc = DDcases(indexNegAcc);
dateVector = 22+[1:length(cases)];
numDays = dateVector(end)-22;

hold on
% H1=area(0:numDays+60,1*ones(size(0:numDays+60)),'FaceColor',[1 0 0],...
%     'FaceAlpha',0.6,'EdgeColor','none');
% H1=area(0:numDays+60,0.1*ones(size(0:numDays+60)),'FaceColor',[1 1 1],...
%     'FaceAlpha',0.2,'EdgeColor','none');
% H1=area(0:numDays+60,.01*ones(size(0:numDays+60)),'FaceColor',[1 1 1],...
%     'FaceAlpha',0.2,'EdgeColor','none');
% H1=area(0:numDays+60,0.001*ones(size(0:numDays+60)),'FaceColor',[1 1 1],...
%     'FaceAlpha',0.2,'EdgeColor','none');
% H1=area(0:numDays+60,0.0001*ones(size(0:numDays+60)),'FaceColor',[1 1 1],...
%     'FaceAlpha',0.2,'EdgeColor','none');
% H1=area(0:numDays+60,0.00001*ones(size(0:numDays+60)),'FaceColor',[1 1 1],...
%     'FaceAlpha',0.2,'EdgeColor','none');
% H1=area(0:numDays+60,0.000001*ones(size(0:numDays+60)),'FaceColor',[1 1 1],...
%     'FaceAlpha',0.2,'EdgeColor','none');
% H1=area(0:numDays+60,0.0000001*ones(size(0:numDays+60)),'FaceColor',[1 1 1],...
%     'FaceAlpha',0.2,'EdgeColor','none');
% text(2.5,1,['100% Pop: ' num2str(pop)])
% text(2.5,0.16,['10% Pop: ' num2str(floor(0.1*pop))])
% text(2.5,0.016,['1% Pop: ' num2str(floor(0.01*pop))])
% text(2.5,0.0016,['0.1% Pop: ' num2str(floor(0.001*pop))])
% text(2.5,0.00016,['0.01% Pop: ' num2str(floor(0.0001*pop))])
% text(dateVector(end)+3,cases(end)./pop,['Cases: ' num2str(cases(end))])
% text(dateVector(end)+3,deaths(end)./pop,['Deaths: ' num2str(deaths(end))])
if Dcases(end) == max(Dcases)
   plot(dateVector(1:3:end),Dcases(1:3:end),'-','DisplayName',[Name],'MarkerSize',8,'LineWidth',2)
   %fprintf('%s is growing at its maximum rate \n',Name) 
else
   plot(dateVector(1:3:end),Dcases(1:3:end),'y-','DisplayName',[Name],'MarkerSize',8,'LineWidth',2,'edgealpha',0.5) 
end

% p2 = semilogy(dateVector(1:3:end),deaths(1:3:end)./pop,'ks','DisplayName',[Name ' Confirmed Deaths'],'MarkerSize',8);
if ~isempty(recovered)
    %p3 = semilogy(dateVector(1:3:end),recovered(1:3:end)./pop,'kp','DisplayName',[Name ' Confirmed Recovery'],'MarkerSize',10);
end
if ~isempty(indexMaxRate)
    %semilogy(indexMaxRate,cases(indexMaxRate)./pop,'r*','MarkerSize',10);
end



