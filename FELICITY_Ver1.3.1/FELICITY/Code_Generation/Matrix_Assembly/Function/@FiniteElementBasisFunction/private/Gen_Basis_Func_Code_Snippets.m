function [obj, CODE] = Gen_Basis_Func_Code_Snippets(obj)
%Gen_Basis_Func_Code_Snippets
%
%   This routine determines what quantities need to be computed for the local
%   basis functions, and then creates the C++ code snippets that will do the
%   computing!

% Copyright (c) 01-15-2018,  Shawn W. Walker

% ensure we have indicated ALL we need,
% i.e. some quantities depend on others so we must make sure to compute those!
obj.Opt = obj.FuncTrans.Resolve_FUNC_Dependencies(obj.Opt);

% copy over for later
obj.FuncTrans.INTERPOLATION = obj.INTERPOLATION;

% SPECIAL CASE
if isa(obj.FuncTrans,'H1_Trans')
    
    % only do this if we are *NOT* interpolating
    if ~obj.INTERPOLATION
        % this will be computed in a separate piece of code
        obj.Opt.Val = false;
        % i.e. we ALWAYS compute this for the basis functions, but we don't do it
        % *here* because these get initialized once in the constructor.  For all
        % other quantities, like .Grad, we compute it for each element in the mesh.
    end
    
    % NOTE: for the case of generating interpolation routines, we need to
    % compute the basis function evaluations (with no derivatives) everytime,
    % b/c the interpolation point is unknown before runtime.
end

% another SPECIAL CASE
if isa(obj.FuncTrans,'Constant_Trans')
    % there is no need to compute the value because it is always 1,
    % i.e. it is initialized in the constructor
    obj.Opt.Val = false;
end

% generate code snippets and store them in an array of structs
CODE = obj.FuncTrans.Output_FUNC_Codes(obj.Opt);

end