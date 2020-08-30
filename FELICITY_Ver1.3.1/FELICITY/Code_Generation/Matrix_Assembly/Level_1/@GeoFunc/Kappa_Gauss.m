function OUT = Kappa_Gauss(obj,varargin)
%Kappa_Gauss
%
%   This outputs a symbolic variable representation of the function:
%   \kappa_G, where \kappa_G is the Gauss curvature on the domain.
%
%   OUT = obj.Kappa_Gauss(ARG_Indices);
%
%   ARG_Indices = (optional) component indices.
%
%   OUT = sym (symbolic) variable.

% Copyright (c) 03-09-2012,  Shawn W. Walker

if strcmp(obj.Domain.Type,'tetrahedron')
    error('You do not need the curvature on a (flat) 3-D domain.');
end
if and(strcmp(obj.Domain.Type,'triangle'),(obj.Domain.GeoDim==2))
    error('You do not need the curvature on a flat 2-D domain.');
end

FUNC = obj.Get_Kappa_Gauss;

OUT = obj.Make_Symbolic(FUNC);

end