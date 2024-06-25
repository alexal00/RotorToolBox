%% Plotting parameters
% Set colors, markers and line stiles in plt structure
% Additionally step is also set which can be further used inide
% functionplot
cmap = colormap(lines(8));
close all
Color =cell(1,8);
for ii=1:8
   Color{ii}= cmap(ii,:);
end
Marker = {'o','+','x','s','d','^','*','.'};
LineStyle = {'-' '--' ':' '-.' '-' '--' ':' '-.'};
plt.Color = Color; plt.Marker = Marker; plt.LineStyle = LineStyle;
step = 128;
plt.step = step;

set(0,"defaultLineLineWidth",2,'DefaultAxesTickLabelInterpreter', 'latex',...
    'DefaultTextInterpreter','latex','DefaultLegendInterpreter','latex');
fid = 1;
% From MATLAB R2016 onwards it seems that the figure font size has
% increased and 12pt seems a good compromise
set(0,'DefaultTextFontSize',11)
set(0,'DefaultAxesFontSize',11)
set(0,'DefaultTextFontName','Times')
set(0,'DefaultAxesFontName','Times') 
% set(0,'defaultlinemarkersize',4);