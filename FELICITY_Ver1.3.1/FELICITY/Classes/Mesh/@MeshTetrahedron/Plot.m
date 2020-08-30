function Plot_Handle = Plot(obj)
%Plot
%
%   This plots the whole tetrahedral mesh.
%
%   Plot_Handle = obj.Plot;

% Copyright (c) 08-19-2009,  Shawn W. Walker

%hold on;
Plot_Handle = tetramesh(obj.ConnectivityList,obj.Points);
view(3);
set(Plot_Handle,'edgecolor','k'); % make mesh black
axis equal;
title(obj.Name);
%hold off;

end