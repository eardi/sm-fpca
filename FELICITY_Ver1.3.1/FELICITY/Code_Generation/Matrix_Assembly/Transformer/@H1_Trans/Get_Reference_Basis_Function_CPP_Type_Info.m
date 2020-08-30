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
%   Note: this output struct must match the fields of obj.f.
%         (see \private\init_func.m)
%   Note: this only acts on one component for H^1 functions.
%   Note: CPP_Type_Info.(Field) can be an array (if multiple expressions
%         are needed).

% Copyright (c) 10-27-2016,  Shawn W. Walker

TD = obj.GeoMap.TopDim;
%GD = obj.GeoMap.GeoDim;

% function value
CPP_Type_Info.Val.Type_str = 'SCALAR';
CPP_Type_Info.Val.Suffix_str = 'Val';
CPP_Type_Info.Val.Comp  = {[1 1]};
CPP_Type_Info.Val.Deriv = {[0 0 0]};
% define the expression
CPP_Type_Info.Val.Expr  = @(v0) v0;

% function gradient (one vector variable)
CPP_Type_Info.Grad.Type_str = ['VEC', '_', num2str(TD), 'x', '1'];
CPP_Type_Info.Grad.Suffix_str = 'Grad';
CPP_Type_Info.Grad.Comp   = {[1 1], [1 1], [1 1]};
CPP_Type_Info.Grad.Deriv  = {[1 0 0], [0 1 0], [0 0 1]};
% correct for topological dimension
CPP_Type_Info.Grad.Comp   = CPP_Type_Info.Grad.Comp(1:TD);
CPP_Type_Info.Grad.Deriv  = CPP_Type_Info.Grad.Deriv(1:TD);
% define the expression
CPP_Type_Info.Grad.Expr  = @(gv) gv(:)'; % ensure it is a row vector

% function hessian
CPP_Type_Info.Hess.Type_str   = ['MAT', '_', num2str(TD), 'x', num2str(TD)];
CPP_Type_Info.Hess.Suffix_str = 'Hess';
CPP_Type_Info.Hess.Comp  = {[1 1], [1 1], [1 1];
                            [1 1], [1 1], [1 1];
                            [1 1], [1 1], [1 1]};
CPP_Type_Info.Hess.Deriv = {[2 0 0], [1 1 0], [1 0 1];
                            [1 1 0], [0 2 0], [0 1 1];
                            [1 0 1], [0 1 1], [0 0 2]};
% correct for topological dimension
CPP_Type_Info.Hess.Comp  = CPP_Type_Info.Hess.Comp(1:TD,1:TD);
CPP_Type_Info.Hess.Deriv = CPP_Type_Info.Hess.Deriv(1:TD,1:TD);
% define the expression
CPP_Type_Info.Hess.Expr  = @(mm) reshape(mm',1,[]); % ensure the rows get concatenated

% function d/ds
CPP_Type_Info.d_ds.Type_str = 'SCALAR';
CPP_Type_Info.d_ds.Suffix_str = 'd_ds';
CPP_Type_Info.d_ds.Comp  = {[1 1]};
CPP_Type_Info.d_ds.Deriv = {[1 0 0]};
% define the expression
CPP_Type_Info.d_ds.Expr  = @(v0) v0;

% function d^2/ds^2
CPP_Type_Info.d2_ds2.Type_str = 'SCALAR';
CPP_Type_Info.d2_ds2.Suffix_str = 'd2_ds2';
CPP_Type_Info.d2_ds2.Comp  = {[1 1]};
CPP_Type_Info.d2_ds2.Deriv = {[2 0 0]};
% define the expression
CPP_Type_Info.d2_ds2.Expr  = @(v0) v0;

% now, remove fields that we don't need
if (~Basis_Opt.Val)
    CPP_Type_Info = rmfield(CPP_Type_Info,'Val');
end
if and(~Basis_Opt.Grad,~Basis_Opt.Hess)
    % note that Hess also needs the gradient
    CPP_Type_Info = rmfield(CPP_Type_Info,'Grad');
end
if (~Basis_Opt.Hess)
    CPP_Type_Info = rmfield(CPP_Type_Info,'Hess');
end
if (~Basis_Opt.d_ds)
    CPP_Type_Info = rmfield(CPP_Type_Info,'d_ds');
end
if (~Basis_Opt.d2_ds2)
    CPP_Type_Info = rmfield(CPP_Type_Info,'d2_ds2');
end

end