function OUT = N(obj,varargin)
%N
%
%   This outputs a symbolic variable representation of the function:
%   N, where N is the oriented normal vector on the domain.
%
%   OUT = obj.N(ARG_Indices);
%
%   ARG_Indices = (optional) component indices.
%
%   OUT = sym (symbolic) variable.

% Copyright (c) 08-01-2011,  Shawn W. Walker

if strcmp(obj.Domain.Type,'interval')
    if (obj.Domain.GeoDim==3)
        error('There is no (single) well-defined normal vector on a 3-D space curve.');
    end
end
if strcmp(obj.Domain.Type,'tetrahedron')
    error('You do not need the normal vector on a 3-D domain.');
end
if and(strcmp(obj.Domain.Type,'triangle'),(obj.Domain.GeoDim==2))
    error('You do not need the normal vector on a flat 2-D domain.');
end

FUNC = obj.Get_N;

FUNC_tilde = obj.Reduce_Components(FUNC,varargin);

OUT = obj.Make_Symbolic(FUNC_tilde);

end