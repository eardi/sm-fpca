function Composed_SymFunc = Compose_Function(obj,SymFunc)
%Compose_Function
%
%   This creates a new FELSymFunc object that comes from composing two
%   functions:  h(...) = f(g(...)), where f is the current 'obj'.
%
%   Composed_SymFunc = obj.Compose_Function(SymFunc);
%
%   SymFunc = the function g to compose with.
%
%   Composed_SymFunc = the new function h.

% Copyright (c) 03-01-2013,  Shawn W. Walker

if ~isa(SymFunc,'FELSymFunc')
    error('Function to compose with must be a FELSymFunc.');
end

% make sure the independent variable names are distinct between the two
% functions
CHK1 = setdiff(obj.Vars,SymFunc.Vars);
CHK2 = setdiff(SymFunc.Vars,obj.Vars);
if or(length(CHK1)~=obj.input_dim,length(CHK2)~=SymFunc.input_dim)
    error('Independent variables of both functions must be distinct!');
end

% first convert the incoming function into a column vector-valued (sym) function
g = SymFunc.Func(:);

% make sure the output of g fits the input of f
if (length(g)~=obj.input_dim)
    error('Output dimension of input function does not fit the input dimension of this function.');
end

TEMP = obj.Func; % init
for ind = 1:obj.input_dim
    TEMP = obj.subs_H(TEMP,obj.Vars{ind},g(ind));
end
if ~isa(TEMP,'sym')
    TEMP = sym(TEMP); % this needs to be done if TEMP is a constant
end

Composed_SymFunc = FELSymFunc(TEMP,SymFunc.Vars);

end