function Eval_Basis = Gen_Basis_Function_Evals(obj,Pts,Max_Deriv_Order)
%Gen_Basis_Function_Evals
%
%   This puts the (sym) basis functions of the reference element into a useful
%   data structure, and computes derivatives (including 0th order) of the basis
%   functions symbolically.  It also stores point evaluations of the basis
%   functions (and their derivatives).
%
%   Eval_Basis = obj.Gen_Basis_Function_Evals(Pts,Max_Deriv_Order);
%
%   Pts = MxT array of point coordinates to evaluate the basis functions at;
%         T = topological dimension of the reference element simplex.
%   Max_Deriv_Order = maximum order of derivatives to compute.
%
%   Eval_Basis = N length array of FELSymBasisCalc objects, where N is the
%                number of local basis functions on the reference element.

% Copyright (c) 03-06-2013,  Shawn W. Walker

% error check
if (size(Pts,2)~=obj.Top_Dim)
    error('Number of vector components of quad points must match topological dimension of element!');
end

if or(strcmp(obj.Element_Type,'constant_one'),isempty(Max_Deriv_Order))
    Eval_Basis = [];
    return;
end

% get independent variable names
if (obj.Top_Dim==1)
    Vars = {'x'};
elseif (obj.Top_Dim==2)
    Vars = {'x', 'y'};
elseif (obj.Top_Dim==3)
    Vars = {'x', 'y', 'z'};
else
    Eval_Basis = [];
    return;
end

% initialize
TEMP = FELSymFunc(obj.Basis(1).phi,Vars);
Eval_Basis = FELSymBasisCalc(TEMP,Max_Deriv_Order);

for k = 1:obj.Num_Basis
    TEMP = FELSymFunc(obj.Basis(k).phi,Vars);
    Eval_Basis(k) = FELSymBasisCalc(TEMP,Max_Deriv_Order);
    Eval_Basis(k) = Eval_Basis(k).Fill_Eval(Pts);
end

end