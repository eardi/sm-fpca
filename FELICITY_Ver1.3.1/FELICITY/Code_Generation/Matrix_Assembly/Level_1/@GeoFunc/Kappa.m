function OUT = Kappa(obj,varargin)
%Kappa
%
%   This outputs a symbolic variable representation of the function:
%   \kappa, where \kappa is the signed (total) curvature on the domain.
%
%   OUT = obj.Kappa(ARG_Indices);
%
%   ARG_Indices = (optional) component indices.
%
%   OUT = sym (symbolic) variable.

% Copyright (c) 08-01-2011,  Shawn W. Walker

if strcmp(obj.Domain.Type,'tetrahedron')
    error('You do not need the curvature on a (flat) 3-D domain.');
end
if and(strcmp(obj.Domain.Type,'triangle'),(obj.Domain.GeoDim==2))
    error('You do not need the curvature on a flat 2-D domain.');
end

FUNC = obj.Get_Kappa;

OUT  = obj.Make_Symbolic(FUNC);

end