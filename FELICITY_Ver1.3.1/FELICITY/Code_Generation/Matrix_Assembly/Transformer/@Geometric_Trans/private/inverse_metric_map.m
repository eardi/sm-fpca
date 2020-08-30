function obj = inverse_metric_map(obj)
%inverse_metric_map
%
%   Get the inverse of the (square) metric matrix PHI.Metric.

% Copyright (c) 05-19-2016,  Shawn W. Walker

num_row = size(obj.PHI.Metric,1);
num_col = size(obj.PHI.Metric,2);

if ~isempty(obj.PHI.Metric)
    if (num_row==num_col)
        if (num_row==1) % curve in 2-D or 3-D
            obj.PHI.Inv_Metric = sym('PHI_Inv_Metric_11');
        elseif (num_row==2) % surface in 3-D
            %obj.PHI.Inv_Metric = sym('[PHI_Inv_Metric_11, PHI_Inv_Metric_12; PHI_Inv_Metric_21, PHI_Inv_Metric_22]');
            obj.PHI.Inv_Metric = sym('PHI_Inv_Metric_%d%d',[2 2]);
        elseif (obj.GeoDim==3)
            % not needed in this case, b/c the PHI.Grad plays this role.
            obj.PHI.Inv_Metric = [];
        else
            error('Not implemented!');
        end
    else
        error('Metric matrix must be square!');
    end
else
    obj.PHI.Inv_Metric = [];
end

end