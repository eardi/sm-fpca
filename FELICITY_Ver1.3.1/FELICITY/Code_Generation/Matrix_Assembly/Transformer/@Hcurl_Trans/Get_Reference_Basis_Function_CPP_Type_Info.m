function CPP_Type_Info = Get_Reference_Basis_Function_CPP_Type_Info(obj,Basis_Opt)
%Get_Reference_Basis_Function_CPP_Type_Info
%
%   Basis function type information, i.e. is the evaluation a scalar,
%   vector, matrix, etc.  And, what derivatives are needed, and for which
%   vector components, etc.  Also, what is the actual expression to
%   evaluate, e.g. are we computing the curl of the vector basis
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

if (TD==1)
    error('Invalid!');
elseif (TD==2) % 2-D curl is a scalar
    % function curl (one scalar variable for Curl)
    CPP_Type_Info.Curl.Type_str   = 'SCALAR';
    CPP_Type_Info.Curl.Suffix_str = 'Curl';
    CPP_Type_Info.Curl.Comp  = {[2 1], [1 1]};
    CPP_Type_Info.Curl.Deriv = {[1 0 0], [0 1 0]};
    % define the expression
    CPP_Type_Info.Curl.Expr  = @(dd) dd(1) - dd(2);
elseif (TD==3) % 3-D curl is a vector
    % function curl (one vector variable for Curl)
    CPP_Type_Info.Curl.Type_str   = 'VEC_3x1';
    CPP_Type_Info.Curl.Suffix_str = 'Curl';
    CPP_Type_Info.Curl.Comp  = {[3 1], [2 1];
                                [1 1], [3 1];
                                [2 1], [1 1]};
    CPP_Type_Info.Curl.Deriv = {[0 1 0], [0 0 1];
                                [0 0 1], [1 0 0];
                                [1 0 0], [0 1 0]};
    % note: these cell arrays will have rows concatenated together
    % define the expression (make it a row vector!)
    CPP_Type_Info.Curl.Expr  = @(dd) [(dd(1) - dd(2)), (dd(3) - dd(4)), (dd(5) - dd(6))];
    % index by concatenated rows
else
    error('Not implemented!');
end

% now, remove fields that we don't need
if (~Basis_Opt.Val)
    CPP_Type_Info = rmfield(CPP_Type_Info,'Val');
end
if (~Basis_Opt.Curl)
    CPP_Type_Info = rmfield(CPP_Type_Info,'Curl');
end

end