function fighandle = functionplot(ax,x,y,step,C,M,LS,N)
% functionplot Imporved plot function every x steps
% 
% Input:
%       * ax: axis handle
%       * x: abscisa data
%       * y: ordinate data
%       * step: only plot every x steps
%       * C: Selected color string
%       * M: Selected marker string
%       * LS: Selected line-style string
%       * N: Selected name string
plot(ax,x,y,"Color",C,'Marker',M,'LineStyle',LS,'DisplayName',N,'MarkerIndices',1:step:length(y)); hold on

end