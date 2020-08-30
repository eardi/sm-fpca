function obj = Compose_Function(obj,SymFunc)
%Compose_Function
%
%   This creates a new FELSymFunc object that comes from composing two
%   functions:  h(...) = f(g(...)), where f is the current 'obj'.
%
%   comp_obj = obj.Compose_Function(SymFunc);
%
%   SymFunc = the function g to compose with.
%
%   (output) obj = the new function h.

% Copyright (c) 10-31-2016,  Shawn W. Walker

% if the input dimension of the "obj" function is zero, then composition makes no sense
% so, ignore it!
if (obj.input_dim==0)
    return;
end

if ~isa(SymFunc,'FELSymFunc')
    error('Function to compose with must be a FELSymFunc.');
end

% make sure the independent variable names are distinct between the two
% functions
Convert_to_String = @(F) char(F);
oV = cellfun(Convert_to_String, obj.Vars, 'UniformOutput', false);
SV = cellfun(Convert_to_String, SymFunc.Vars, 'UniformOutput', false);
CHK1 = setdiff(oV,SV);
CHK2 = setdiff(SV,oV);
if or(length(CHK1)~=obj.input_dim,length(CHK2)~=SymFunc.input_dim)
    error('Independent variables of both functions must be distinct!');
end

% first convert the incoming function into a col vector-valued (sym) function
g = SymFunc.Func(:);

% make sure the output of g fits the input of f
if (length(g)~=obj.input_dim)
    error('Output dimension of input function does not fit the input dimension of this function.');
end

TEMP = obj.subs_H(obj.Func,obj.Vars',g);
if ~isa(TEMP,'sym')
    TEMP = sym(TEMP); % this needs to be done if TEMP is a constant
end

% store the new composed function
obj.Func = TEMP;
obj.Vars = SymFunc.Vars; % update independent variables

end