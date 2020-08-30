function obj = inverse_det_metric(obj)
%inverse_det_metric
%
%   Get the INVERSE of determinant of the metric, 1 / det(PHI.Metric).

% Copyright (c) 02-20-2012,  Shawn W. Walker

if ~isempty(obj.PHI.Det_Metric)
    obj.PHI.Inv_Det_Metric = sym('Inv_Det_Metric');
else
    obj.PHI.Inv_Det_Metric = [];
end

end