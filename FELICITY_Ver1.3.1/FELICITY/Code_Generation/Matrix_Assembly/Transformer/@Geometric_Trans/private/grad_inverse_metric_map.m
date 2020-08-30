function obj = grad_inverse_metric_map(obj)
%grad_inverse_metric_map
%
%   Get the gradient (in local coordinates) of the inverse of the (square) metric matrix
%   PHI.Metric.

% Copyright (c) 05-19-2016,  Shawn W. Walker

num_row = size(obj.PHI.Metric,1);
num_col = size(obj.PHI.Metric,2);

if ~isempty(obj.PHI.Metric)
    if (num_row==num_col)
        if (num_row==1) % curve in 2-D or 3-D
            obj.PHI.Grad_Inv_Metric = sym('PHI_Grad_Inv_Metric_1_11');
        elseif (num_row==2) % surface in 3-D
            obj.PHI.Grad_Inv_Metric(2,2,2) = sym('0'); % init
%             obj.PHI.Grad_Inv_Metric(:,:,1) = sym('[PHI_Grad_Inv_Metric_1_11, PHI_Grad_Inv_Metric_1_12; PHI_Grad_Inv_Metric_1_21, PHI_Grad_Inv_Metric_1_22]');
%             obj.PHI.Grad_Inv_Metric(:,:,2) = sym('[PHI_Grad_Inv_Metric_2_11, PHI_Grad_Inv_Metric_2_12; PHI_Grad_Inv_Metric_2_21, PHI_Grad_Inv_Metric_2_22]');
            obj.PHI.Grad_Inv_Metric(:,:,1) = sym('PHI_Grad_Inv_Metric_1_%d%d',[2 2]);
            obj.PHI.Grad_Inv_Metric(:,:,2) = sym('PHI_Grad_Inv_Metric_2_%d%d',[2 2]);
        elseif (obj.GeoDim==3)
            % not needed in this case, b/c the PHI.Hess plays this role.
            obj.PHI.Grad_Inv_Metric = [];
        else
            error('Not implemented!');
        end
    else
        error('Metric matrix must be square!');
    end
else
    obj.PHI.Grad_Inv_Metric = [];
end

end