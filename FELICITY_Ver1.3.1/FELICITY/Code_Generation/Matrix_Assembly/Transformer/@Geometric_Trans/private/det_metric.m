function obj = det_metric(obj)
%det_metric
%
%   Get the determinant of the metric tensor, det(PHI.Metric)).

% Copyright (c) 05-19-2016,  Shawn W. Walker

if ~isempty(obj.PHI.Metric)
    obj.PHI.Det_Metric = sym('Det_Metric');
else
    obj.PHI.Det_Metric = [];
end

end