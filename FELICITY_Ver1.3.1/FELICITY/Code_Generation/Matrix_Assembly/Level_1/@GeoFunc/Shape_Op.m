function OUT = Shape_Op(obj,varargin)
%Shape_Op
%
%   This outputs a symbolic variable representation of the shape operator of the domain.
%
%   For a 2-D surface in 3-D, the shape operator is:  \nabla_\Gamma \vn,
%   where \vn is the normal vector, and \nabla_\Gamma is the surface gradient on the
%   surface \Gamma.
%
%   For a 1-D curve in 2-D or 3-D, the shape operator is: \kappa \vt \otimes \vt,
%   where \vt is the tangent vector, and \kappa is the scalar curvature of the curve.
%
%   In both case, the shape operator is a symmetric matrix.
%
%   For "flat" domains, the shape operator trivially vanishes (zero matrix).
%
%   OUT = obj.Shape_Op(ARG_Indices);
%
%   ARG_Indices = (optional) component indices.
%
%   OUT = sym (symbolic) variable.

% Copyright (c) 08-15-2014,  Shawn W. Walker

GD = obj.Domain.GeoDim;
TD = obj.Domain.Top_Dim;
if (TD >= GD)
    disp('The Shape Operator is only available when the geometric dimension is');
    disp('     *strictly* greater than the topological dimension of the domain!');
    error('STOP!');
end

FUNC = obj.Get_Shape_Op;

FUNC_tilde = obj.Reduce_Components(FUNC,varargin);

OUT = obj.Make_Symbolic(FUNC_tilde);

end