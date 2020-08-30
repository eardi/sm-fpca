function Plot_Handle = Plot_Simplex_Quality(obj,Qual,Num_Bins)
%Plot_Simplex_Quality
%
%   This plots the quality measures of all simplices in the global mesh.
%
%   Plot_Handle = obj.Plot_Simplex_Quality(Qual,Num_Bins);
%
%   Qual = column vector of element qualities.
%   Num_Bins = number of bins in histogram.
%
%   Plot_Handle = handle to figure.

% Copyright (c) 08-19-2009,  Shawn W. Walker

if nargin < 3
    Num_Bins = 10;
end

hist(Qual,Num_Bins);

title(['Simplex Qualities (Ratio)']);

% get some stats
STAT_STR = ['Min (Worst) Quality = ',     num2str(min(Qual),'%1.3f'), ...
            '  |  Max (Best) Quality = ', num2str(max(Qual),'%1.3f'), ...
            '  |  Average Quality = ',    num2str(mean(Qual),'%1.3f'), ...
            '  |  STD Quality = ',        num2str(std(Qual),'%1.3f')];
xlabel(STAT_STR);

Vol = obj.Volume;
Inverted_Elem = (Vol <= 0);
Num_Inverted = sum(Inverted_Elem);
if Num_Inverted > 0
    disp(['There are ', num2str(Num_Inverted,'%d'), ' inverted (or degenerate) elements in the mesh!']);
end

Plot_Handle = gcf;

end