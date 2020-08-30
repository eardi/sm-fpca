function obj = Fill_Eval(obj,Pt)
%Fill_Eval
%
%   This evaluates the base function, and all its (desired) derivatives at the
%   given points and stores them internally in this object.
%   
%   obj = obj.Fill_Eval(Pt);
%
%   Pt = MxT matrix of point coordinates to evaluate the functions.
%        M = number of points.
%        T = number of independent variables in the function.

% Copyright (c) 01-11-2018,  Shawn W. Walker

if and(obj.Base_Func.input_dim > 0, size(Pt,2) > obj.Base_Func.input_dim)
    error('The dimension of the points is greater than the number of independent variables!');
end

obj.Pt = Pt; % store it

% evaluate
obj.Base_Value = obj.Base_Func.Eval(Pt);

% get keys to derivatives of functions (with respect to original variables)
KEYS = obj.Deriv_Func.keys;

% init Map container
obj.Deriv_Value = containers.Map;

% fill 'em up
for ind = 1:length(KEYS)
    obj.Deriv_Value(KEYS{ind}) = obj.Deriv_Func(KEYS{ind}).Eval(Pt);
end

end