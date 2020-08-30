function [Basis_qp_eval, FORMAT_STR] = Process_Basis_Eval_to_CPP_Code(Quad_Pt,Eval_Basis,...
                                                             Basis_Comp_Set,Deriv_Set,Eval_Expression)
%Process_Basis_Eval_to_CPP_Code
%
%   This collects basis function evaluations into a convenient matrix
%   structure.
%
%   Basis_qp_eval = QxB cell array, where Q is the number of quad points
%                   and B is the number of basis functions.
%                   Each entry of the cell array is a row vector, RV,
%                   representing the value, gradient, hessian, etc. of the
%                   particular basis function at the given quad point.
%   FORMAT_STR    = useful for writing the data to file.
%
%   Examples:
%            Value: RV = [f](qp)
%         Gradient: RV = [df/dx, df/dy, df/dz](qp)
%          Hessian: RV = [d^2f/dx^2, d^2f/dxdy, d^2f/dxdz,...
%                         d^2f/dxdy, d^2f/dy^2, d^2f/dydz,...
%                         d^2f/dxdz, d^2f/dydz, d^2f/dz^2](qp)

% Copyright (c) 10-28-2016,  Shawn W. Walker

Num_Comp_Indices = length(Basis_Comp_Set(:));
Num_QP = size(Quad_Pt,1);
Num_Basis = length(Eval_Basis);

% initialize
Basis_qp_eval = mat2cell(zeros(Num_QP,Num_Comp_Indices*Num_Basis), ones(1,Num_QP), Num_Comp_Indices*ones(1,Num_Basis));

% evaluate the expression on the basis functions
Basis_Sym = Process_Symbolic_Basis_Eval(Eval_Basis,Basis_Comp_Set,Deriv_Set,Eval_Expression);
if (length(Basis_Sym)~=Num_Basis)
    error('Invalid!');
end

% fill in expression evaluation
for bi=1:Num_Basis
    
    % get the expression
    Sym_Expression = Basis_Sym(bi).Expr;
    
    % evaluate at quad points
    Eval_at_Quad = Sym_Expression.Eval(Quad_Pt);
    
    % make sure this is a row cell array
    if (size(Eval_at_Quad,1)~=1)
        error('The Eval_Expression must give a row vector ALWAYS!');
    end
    
    % convert to a matrix
    Eval_Length = length(Eval_at_Quad);
    Eval_at_Quad_mat = cell2mat(Eval_at_Quad);
    
    % store it in the output cell array
    for qi = 1:Num_QP
        Basis_qp_eval{qi,bi} = Eval_at_Quad_mat(qi,:);
    end
end

% init
FORMAT_STR = '%2.17E';
for k=2:Eval_Length
    FORMAT_STR = [FORMAT_STR, ', %2.17E'];
end

end