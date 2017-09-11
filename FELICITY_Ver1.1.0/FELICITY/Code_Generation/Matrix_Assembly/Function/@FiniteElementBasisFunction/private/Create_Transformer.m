function obj = Create_Transformer(obj,GeomFunc)
%Create_Transformer
%
%   This creates a transformer for a FE basis function.

% Copyright (c) 05-31-2012,  Shawn W. Walker

if length(GeomFunc) > 1
    error('This only accepts a single GeomFunc!');
end

if isempty(GeomFunc)
    obj.FuncTrans = [];
else
    F_NAME = [obj.Func_Name, '_', obj.Type];
    FuncTrans_Handle = str2func(obj.Elem.Transformation);
    obj.FuncTrans = feval(FuncTrans_Handle,F_NAME,GeomFunc.GeoTrans);
end

end