function obj = metric_map(obj)
%metric_map
%
%   Get the metric for the map PHI.Grad (useful for curves and surfaces in
%   higher dimensions).

% Copyright (c) 02-20-2012,  Shawn W. Walker

num_row = size(obj.PHI.Grad,1);
num_col = size(obj.PHI.Grad,2);

if (num_row > num_col)
    if (num_col==1) % curve
        obj.PHI.Metric = sym('[PHI_Metric_11]');
    elseif (num_col==2) % surface
        obj.PHI.Metric = sym('[PHI_Metric_11, PHI_Metric_12; PHI_Metric_21, PHI_Metric_22]');
    else
        error('Not implemented!');
    end
else
    obj.PHI.Metric = [];
end

end