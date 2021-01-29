function covidPlot2(cases,death,pop,name)
p1 = plot()
hspan!(p1,[0,1e2], color  = :red, alpha   = 0.6, labels = false);
hspan!(p1,[0,1e1], color  = :white, alpha = 0.1, labels = false);
hspan!(p1,[0,1e0], color  = :white, alpha = 0.1, labels = false);
hspan!(p1,[0,1e-1], color = :white, alpha = 0.1, labels = false);
hspan!(p1,[0,1e-2], color = :white, alpha = 0.1, labels = false);
hspan!(p1,[0,1e-3], color = :white, alpha = 0.1, labels = false);
hspan!(p1,[0,1e-4], color = :white, alpha = 0.1, labels = false);
hspan!(p1,[0,1e-5], color = :white, alpha = 0.1, labels = false);
hspan!(p1,[0,1e-6], color = :white, alpha = 0.1, labels = false);
scatter!(1:size(cases)[2],
      100*cases[1,:]./pop,lab=name*" COVID Cases",
      scale=:log10,
      yticks = [1e-6,1e-5,1e-4,1e-3,1e-2,1e-1,1,1e1,1e2],
      yaxis="Percent of Country", xaxis="Days since Jan 22",
      marker =:o,
      color =:green)
scatter!(1:size(cases)[2],
      100*death[1,:]./pop,lab=name*" COVID Deaths",
      scale=:log10,
      yticks = [1e-6,1e-5,1e-4,1e-3,1e-2,1e-1,1,1e1,1e2],
      yaxis="Percent of Country", xaxis="Days since Jan 22",
      marker =:x,
      color =:black)
 plot!(xscale=:identity,xticks=0:100:500, legend=:bottomright)
 labelCases = cases[1,end];
 labelDeath = death[1,end];
 annotate!(size(cases)[2]+5, 200*cases[1,end]./pop, ha="left",va="bottom","$labelCases")
 annotate!(size(cases)[2]+5, 200*death[1,end]./pop, ha="left",va="bottom","$labelDeath")
 xlims!((0,500))
 ylims!((1e-6,100))
 png(p1,"Figures/UnitedStates/$name.png")
end
