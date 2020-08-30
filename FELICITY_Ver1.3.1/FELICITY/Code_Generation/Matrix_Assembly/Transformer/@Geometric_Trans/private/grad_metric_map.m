function obj = grad_metric_map(obj)
%grad_metric_map
%
%   Get the gradient (in local coordinates) of the metric for the map PHI.Grad (useful for
%   curves and surfaces in higher dimensions).

% Copyright (c) 05-19-2016,  Shawn W. Walker

num_row = size(obj.PHI.Grad,1);
num_col = size(obj.PHI.Grad,2);

if (num_row > num_col)
    if (num_col==1) % curve
        obj.PHI.Grad_Metric = sym('PHI_Grad_Metric_1_11');
    elseif (num_col==2) % surface
        obj.PHI.Grad_Metric(2,2,2) = sym('0'); % init
%         obj.PHI.Grad_Metric(:,:,1) = sym('[PHI_Grad_Metric_1_11, PHI_Grad_Metric_1_12; PHI_Grad_Metric_1_21, PHI_Grad_Metric_1_22]');
%         obj.PHI.Grad_Metric(:,:,2) = sym('[PHI_Grad_Metric_2_11, PHI_Grad_Metric_2_12; PHI_Grad_Metric_2_21, PHI_Grad_Metric_2_22]');
        obj.PHI.Grad_Metric(:,:,1) = sym('PHI_Grad_Metric_1_%d%d',[2 2]);
        obj.PHI.Grad_Metric(:,:,2) = sym('PHI_Grad_Metric_2_%d%d',[2 2]);
    else
        error('Not implemented!'); % not needed here...
    end
else
    obj.PHI.Grad_Metric = [];
end

end