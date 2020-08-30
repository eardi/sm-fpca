function [R, C] = Get_Element_Info_For_Each_DoF(obj)
%Get_Element_Info_For_Each_DoF
%
%   This returns a map from each unique global DoF index to the rows and columns
%   of obj.DoFmap that contain the DoF index.
%
%   [R, C] = obj.Get_Element_Info_For_Each_DoF;
%
%   R = column vector (length is obj.num_dof); R(i) gives the row index (into
%       obj.DoFmap) that contains DoF #i.
%   C = column vector (length is obj.num_dof); C(i) gives the local basis
%       function index ( in obj.DoFmap(R(i),:) ) for DoF #i.

% Copyright (c) 01-01-2011,  Shawn W. Walker

Cell_Ind = (1:1:size(obj.DoFmap,1))';

R = zeros(obj.max_dof,1);
C = zeros(obj.max_dof,1);

% init
R(obj.DoFmap(:,1),1) = Cell_Ind;
C(obj.DoFmap(:,1),1) = 1;
% continue
for ind = 2:size(obj.DoFmap,2)
    R(obj.DoFmap(:,ind),1) = Cell_Ind;
    C(obj.DoFmap(:,ind),1) = ind;
end

% error check
if or((min(R) < 1),(min(C) < 1))
    error('All indices must be positive.  The DoFmap must be screwed up!');
end

end