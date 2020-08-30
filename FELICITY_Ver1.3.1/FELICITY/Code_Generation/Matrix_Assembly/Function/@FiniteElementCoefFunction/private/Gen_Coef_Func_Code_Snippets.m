function [obj, CODE] = Gen_Coef_Func_Code_Snippets(obj)
%Gen_Coef_Func_Code_Snippets
%
%   This routine determines what quantities need to be computed for the coef.
%   functions, and then creates the C++ code snippets that will do the
%   computing!

% Copyright (c) 02-06-2013,  Shawn W. Walker

% ensure we have indicated ALL we need,
% i.e. some quantities depend on others so we must make sure to compute those!
obj.Opt = obj.FuncTrans.Resolve_FUNC_Dependencies(obj.Opt);

% copy interpolation status
obj.FuncTrans.INTERPOLATION = obj.INTERPOLATION;

% generate code snippets and store them in an array of structs
CODE = obj.FuncTrans.Output_COEF_FUNC_Codes(obj.Opt);

end