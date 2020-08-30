function Plot_Handle = Plot_Simplex_Angles(obj,Angles,Num_Bins)
%Plot_Simplex_Angles
%
%   This plots the angles of all simplices in the global mesh.
%
%   Plot_Handle = obj.Plot_Simplex_Angles(Angles,Num_Bins);
%
%   Angles = matrix of element angles.
%   Num_Bins = number of bins in histogram.
%
%   Plot_Handle = handle to figure.

% Copyright (c) 02-14-2013,  Shawn W. Walker

if nargin < 3
    Num_Bins = 10;
end

% convert to degrees
Angles_deg = (180/pi) * Angles(:);

hist(Angles_deg,Num_Bins);

title(['Simplex Angles (degrees)']);

% get some stats
STAT_STR = ['Min Angle = ',          num2str(min(Angles_deg),'%1.3f'), ...
            '  |  Max Angle = ',     num2str(max(Angles_deg),'%1.3f'), ...
            '  |  Average Angle = ', num2str(mean(Angles_deg),'%1.3f'), ...
            '  |  STD Angle = ',     num2str(std(Angles_deg),'%1.3f')];
xlabel(STAT_STR);

Plot_Handle = gcf;

end