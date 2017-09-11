function OUT = VecKappa(obj,varargin)
%VecKappa
%
%   This outputs a symbolic variable representation of the function:
%   K, where K is the oriented vector (total) curvature on the domain.
%
%   OUT = obj.VecKappa(ARG_Indices);
%
%   ARG_Indices = (optional) component indices.
%
%   OUT = sym (symbolic) variable.

% Copyright (c) 08-01-2011,  Shawn W. Walker

if strcmp(obj.Domain.Type,'tetrahedron')
    error('You do not need the curvature vector on a (flat) 3-D domain.');
end
if and(strcmp(obj.Domain.Type,'triangle'),(obj.Domain.GeoDim==2))
    error('You do not need the curvature vector on a flat 2-D domain.');
end

FUNC = obj.Get_VecKappa;

FUNC_tilde = obj.Reduce_Components(FUNC,varargin);

OUT = obj.Make_Symbolic(FUNC_tilde);

end