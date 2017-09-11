function BC = cartToBary(obj,EI,XC)
%cartToBary
%
%   This mimics the analogous MATLAB:TriRep method.
%   Note: this method only uses the x-coordinate of the XC coordinates,
%   which is analogous to the MATLAB:TriRep.cartToBary method, i.e. if you have
%   a 2-D triangulation in 3-D, MATLAB:TriRep.cartToBary ignores the
%   z-coordinate.
%
%   BC = obj.cartToBary(EI,XC);
%
%   EI = column vector (length M) of edge (cell) indices in the mesh.
%   XC = MxD matrix of corresponding global coordinates, where D = geometric
%        dimension; columns 2, 3, are ignored.
%
%   BC = barycentric coordinates. Mx(T+1) matrix, where T = topological
%        dimension.

% Copyright (c) 04-13-2011,  Shawn W. Walker

if isempty(EI)
    EI = (1:1:obj.Num_Cell)';
end
if (size(XC,2) < 1)
    error('Coordinates must have at least x-values!');
end
if (size(XC,1)~=length(EI))
    error('Coordinates and edge indices must have the same number of rows!');
end

% get difference between head and tail
V1  = obj.X(obj.Triangulation(EI,2),1) - obj.X(obj.Triangulation(EI,1),1);

% solve for ``t''
t0 = (XC(:,1) - obj.X(obj.Triangulation(EI,1),1)) ./ V1;

% get barycentric coordinates
BC = [(1 - t0), t0];

end