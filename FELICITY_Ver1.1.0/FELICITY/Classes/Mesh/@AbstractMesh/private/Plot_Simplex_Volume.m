function Plot_Handle = Plot_Simplex_Volume(obj,Vol,Num_Bins)
%Plot_Simplex_Volume
%
%   This plots the volume (geometric measure) of all simplices in the global
%   mesh.
%
%   Plot_Handle = obj.Plot_Simplex_Volume(Vol,Num_Bins);
%
%   Vol = column vector of element volumes.
%   Num_Bins = number of bins in histogram.
%
%   Plot_Handle = handle to figure.

% Copyright (c) 08-19-2009,  Shawn W. Walker

if nargin < 3
    Num_Bins = 10;
end

hist(Vol,Num_Bins);

title(['Simplex Volumes']);

% get some stats
STAT_STR = ['Min Volume = ',        num2str(min(Vol),'%1.3f'), ...
         '  |  Max Volume = ',      num2str(max(Vol),'%1.3f'), ...
         '  |  Average Volume = ',  num2str(mean(Vol),'%1.3f'), ...
         '  |  STD Volume = ',      num2str(std(Vol),'%1.3f')];
xlabel(STAT_STR);

Inverted_Elem = (Vol <= 0);
Num_Inverted = sum(Inverted_Elem);
if Num_Inverted > 0
    disp(['There are ', num2str(Num_Inverted,'%d'), ' inverted (or degenerate) elements in the mesh!']);
end

Plot_Handle = gcf;

end