function XC = barycentricToCartesian(obj,EI,BC)
%barycentricToCartesian
%
%   This mimics the analogous MATLAB:triangulation method.
%
%   XC = obj.barycentricToCartesian(EI,BC);
%
%   EI = column vector (length M) of edge (cell) indices in the mesh.
%        If EI = [], then all edges in the mesh are considered.
%   BC = barycentric coordinates. Mx(T+1) matrix, where T = topological
%        dimension.
%
%   XC = MxD matrix of corresponding global coordinates, where D = geometric
%        dimension.

% Copyright (c) 04-13-2011,  Shawn W. Walker

if isempty(EI)
    EI = (1:1:obj.Num_Cell)';
end
if (size(BC,2)~=2)
    error('Barycentric coordinates must have 2 columns for 1-D (topological dimension) meshes!');
end
if (size(BC,1)~=length(EI))
    error('Barycentric coordinates and edge indices must have the same number of rows!');
end

% init
Geo_Dim = size(obj.Points,2);
XC = zeros(length(EI),Geo_Dim);

% compute coordinates
XC(:,1) = BC(:,1).*obj.Points(obj.ConnectivityList(EI,1),1) + BC(:,2).*obj.Points(obj.ConnectivityList(EI,2),1);
for ind = 2:Geo_Dim
    XC(:,ind) = BC(:,1).*obj.Points(obj.ConnectivityList(EI,1),ind) + BC(:,2).*obj.Points(obj.ConnectivityList(EI,2),ind);
end

end