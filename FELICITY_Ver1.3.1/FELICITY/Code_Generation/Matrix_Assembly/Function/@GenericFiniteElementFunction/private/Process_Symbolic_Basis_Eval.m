function Basis_Sym = Process_Symbolic_Basis_Eval(Eval_Basis,Basis_Comp_Set,Deriv_Set,Eval_Expression)
%Process_Symbolic_Basis_Eval
%
%   This collects (symbolic) basis function evaluations into a convenient
%   matrix structure.
%
%   Basis_Sym = 1xB struct array, containing FELSymFunc's representing
%               symbolic expressions of the given basis functions.
%
%   Examples:
%            Value: [f]
%         Gradient: [df/dx, df/dy, df/dz]
%          Hessian: [d^2f/dx^2, d^2f/dxdy, d^2f/dxdz,...
%                    d^2f/dxdy, d^2f/dy^2, d^2f/dydz,...
%                    d^2f/dxdz, d^2f/dydz, d^2f/dz^2]
%
%   NOTE: each symbolic expression is flattened into a ROW vector!

% Copyright (c) 10-28-2016,  Shawn W. Walker

% make Tensor_Comp_Set into a row vector (concatenate rows)
BCS = Basis_Comp_Set';
Basis_Comp_Set_Row = BCS(:)';
Num_Comp_Indices = length(Basis_Comp_Set_Row);

% make Deriv_Set into a row vector (concatenate rows)
TDS = Deriv_Set';
Deriv_Set_Row = TDS(:)';

% error check
if (Num_Comp_Indices~=length(Deriv_Set_Row))
    error('Invalid!');
end

% init
Multiindex_Length = Eval_Basis(1).Get_Length_Of_Multiindex;

% initialize
Num_Basis = length(Eval_Basis);

% create a symbolic zero function of correct dimension
ZZ = sym(zeros(1,Num_Comp_Indices));

% fill in basis function (derivative) evaluation
Basis_Sym(Num_Basis).Expr = [];
for bi=1:Num_Basis
    Sym_Func_Eval = ZZ; % init
    
    % get derivatives of various components
    for ci = 1:Num_Comp_Indices
        Deriv_Multiindex = Deriv_Set_Row{ci}(1,1:Multiindex_Length);
        Sym_TEMP = Eval_Basis(bi).Get_Derivative(Deriv_Multiindex);
        Basis_Comp = Basis_Comp_Set_Row{ci};
        Sym_Func_Eval(ci) = Sym_TEMP.Func(Basis_Comp(1),Basis_Comp(2));
        % Note: this last line will collapse a matrix-valued symbolic
        % function into a ROW vector
    end
    
    % evaluate the expression
    Basis_Sym(bi).Expr = FELSymFunc(Eval_Expression(Sym_Func_Eval),Sym_TEMP.Vars);
end

end