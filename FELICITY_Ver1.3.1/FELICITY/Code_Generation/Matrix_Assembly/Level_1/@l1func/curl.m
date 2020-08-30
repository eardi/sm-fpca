function OUT = curl(obj,varargin)
%curl
%
%   This outputs a symbolic variable representation of the function:
%   \nabla \times vv
%
%   Note: this is only useful for intrinsic vector-valued functions.
%   Note: in 2-D, this maps a vector to a scalar (the scalar curl/rotated divergence).
%         in 3-D, this is the usual (vector-valued) curl operator.
%
%   OUT = obj.curl(ARG_Indices);
%
%   ARG_Indices = (optional) component indices.
%
%   OUT = sym (symbolic) variable.

% Copyright (c) 11-04-2016,  Shawn W. Walker

if ~strcmp(obj.Element.Elem.Transformation,'Hcurl_Trans')
    error('You can only use .curl with H(curl) spaces (i.e. Nedelec 1st Kind, 2nd Kind, etc...)!');
end

obj.Name = inputname(1); % save the external variable name

TD = obj.Element.Domain.GeoDim;
GD = obj.Element.Domain.GeoDim;
if (TD~=GD)
    error('Not implemented!')
end

% choose form based on dimension
if (TD==2)
    % because scalar valued
    FUNC = obj.Get_Tensor_Components;
elseif (TD==3)
    % because vector valued
    FUNC = obj.Get_All_Components;
else
    error('Not valid or not implemented!');
end

FUNC_curl = obj.Append_curl(FUNC);

FUNC_tilde = obj.Reduce_Components(FUNC_curl,varargin);

OUT = obj.Make_Symbolic(FUNC_tilde);

end