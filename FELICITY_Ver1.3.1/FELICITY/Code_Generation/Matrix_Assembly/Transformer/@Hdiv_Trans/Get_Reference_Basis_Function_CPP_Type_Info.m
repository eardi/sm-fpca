function CPP_Type_Info = Get_Reference_Basis_Function_CPP_Type_Info(obj,Basis_Opt)
%Get_Reference_Basis_Function_CPP_Type_Info
%
%   Basis function type information, i.e. is the evaluation a scalar,
%   vector, matrix, etc.  And, what derivatives are needed, and for which
%   vector components, etc.  Also, what is the actual expression to
%   evaluate, e.g. are we computing the divergence of the vector basis
%   function?
%
%   Basis_Opt = struct indicating which quantities we need.
%
%   Note: this output struct must match the fields of obj.vv.
%         (see \private\init_func.m)
%   Note: CPP_Type_Info.(Field) can be an array (if multiple expressions
%         are needed).

% Copyright (c) 10-27-2016,  Shawn W. Walker

TD = obj.GeoMap.TopDim;
%GD = obj.GeoMap.GeoDim;

% we do *not* include Orientation b/c it doesn't need evaluation of anything

% function value (one vector variable for Val)
CPP_Type_Info.Val.Type_str   = ['VEC', '_', num2str(TD), 'x', '1'];
CPP_Type_Info.Val.Suffix_str = 'Val';
CPP_Type_Info.Val.Comp  = {[1 1], [2 1], [3 1]};
CPP_Type_Info.Val.Deriv = {[0 0 0], [0 0 0], [0 0 0]};
% correct for topological dimension
CPP_Type_Info.Val.Comp  = CPP_Type_Info.Val.Comp(1:TD);
CPP_Type_Info.Val.Deriv = CPP_Type_Info.Val.Deriv(1:TD);
% define the expression
CPP_Type_Info.Val.Expr  = @(vv) vv(:)'; % make this a row vector

% function divergence (one scalar variable for Div)
CPP_Type_Info.Div.Type_str   = 'SCALAR';
CPP_Type_Info.Div.Suffix_str = 'Div';
CPP_Type_Info.Div.Comp  = {[1 1], [2 1], [3 1]};
CPP_Type_Info.Div.Deriv = {[1 0 0], [0 1 0], [0 0 1]};
% correct for topological dimension
CPP_Type_Info.Div.Comp  = CPP_Type_Info.Div.Comp(1:TD);
CPP_Type_Info.Div.Deriv = CPP_Type_Info.Div.Deriv(1:TD);
% define the expression
CPP_Type_Info.Div.Expr  = @(dd) sum(dd);

% now, remove fields that we don't need
if (~Basis_Opt.Val)
    CPP_Type_Info = rmfield(CPP_Type_Info,'Val');
end
if (~Basis_Opt.Div)
    CPP_Type_Info = rmfield(CPP_Type_Info,'Div');
end

end