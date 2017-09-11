function obj = Compose_With_Function(obj,SymFunc)
%Compose_With_Function
%
%   This composes all of the internal functions (the base function and its
%   derivatives) with the given FELSymFunc (symbolic function), i.e.
%   obj.Base_Func and all of the obj.Deriv_Func get composed with the given
%   function SymFunc.  See 'FELSymFunc.Compose_Function' for more info.
%
%   Note: each function is composed AFTER the derivatives have been computed.
%   In other words, we are restricting these functions (via SymFunc) to the
%   domain of SymFunc.
%
%   obj = obj.Compose_With_Function(SymFunc);
%
%   SymFunc = FELSymFunc object; the function to compose with.

% Copyright (c) 03-04-2013,  Shawn W. Walker

% record the original independent variables (so we can still access the
% derivatives correctly)
obj.Orig_Vars = obj.Base_Func.Vars;

% compose base function with given function
obj.Base_Func = obj.Base_Func.Compose_Function(SymFunc);

% get keys to derivatives of functions (with respect to original variables)
KEYS = obj.Deriv_Func.keys;

% compose derivatives of base function with given function
for ind = 1:length(KEYS)
    obj.Deriv_Func(KEYS{ind}) = obj.Deriv_Func(KEYS{ind}).Compose_Function(SymFunc);
end

end