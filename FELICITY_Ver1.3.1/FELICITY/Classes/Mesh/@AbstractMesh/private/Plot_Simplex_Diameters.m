function Plot_Handle = Plot_Simplex_Diameters(obj,Diam,Num_Bins)
%Plot_Simplex_Diameters
%
%   This plots the diameters of all simplices in the global mesh.
%
%   Plot_Handle = obj.Plot_Simplex_Diameters(Diam,Num_Bins);
%
%   Diam = vector of element diameters.
%   Num_Bins = number of bins in histogram.
%
%   Plot_Handle = handle to figure.

% Copyright (c) 08-29-2016,  Shawn W. Walker

if nargin < 3
    Num_Bins = 10;
end

Plot_Handle = figure;
histogram(Diam,Num_Bins);

title(['Simplex Diameters']);

% get some stats
STAT_STR = ['Min Diam = ',          num2str(min(Diam),'%0.4g'), ...
            '  |  Max Diam = ',     num2str(max(Diam),'%0.4g'), ...
            '  |  Average Diam = ', num2str(mean(Diam),'%0.4g'), ...
            '  |  STD Diam = ',     num2str(std(Diam),'%0.4g')];
xlabel(STAT_STR);

end