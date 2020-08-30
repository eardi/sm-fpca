function basis = basis_vector_polys_deg_k_Sk(indep_vars,deg_k)
%basis_vector_polys_deg_k_Sk
%
%   This returns a set of vector-valued basis polynomials in the given
%   independent variables, of exactly degree = k, that satisfy the
%   following condition:
%
%   x \cdot p = 0, for all p in the set, where x is the coordinate vector,
%   e.g. x = (x1,x2,x3).
%   
%   This is useful for computing basis functions of H(curl).  The resulting
%   set of basis functions is denoted S_k.
%
%   indep_vars = col. vector of symbolic independent vars;
%                all must be distinct!
%                Note: the dimension is assumed to match length(indep_vars).
%   deg_k      = exact degree of basis polynomials.

% Copyright (c) 10-03-2016,  Shawn W. Walker

% check that independent variables are distinct
num_vars = length(indep_vars);
var_list = symvar(indep_vars);
if length(var_list)~=num_vars
    error('Independent variables are not distinct!');
end

% the dimension is the same as the number of independent variables
dim = num_vars;

if (deg_k <= 0)
    % the set is empty
    basis = [];
    return;
end

if (dim==1)
    error('Invalid!');
elseif (dim==2)
    num_basis = deg_k;
    basis(num_basis).func = []; % init
    
    % init
    x1  = indep_vars(1);
    x2  = indep_vars(2);
    P_1 = [-x2;x1];
    
    P_tilde_k_minus_1_basis = basis_polys_deg_k(indep_vars,deg_k-1,true);
    % error check
    if (num_basis~=length(P_tilde_k_minus_1_basis))
        error('Invalid!  Number of basis functions is not correct!');
    end
    % fill it up
    for ii = 1:num_basis
        basis(ii).func = P_tilde_k_minus_1_basis(ii).func * P_1;
    end
    
elseif (dim==3)
    num_basis = deg_k*(deg_k+2);
    basis(num_basis).func = []; % init
    
    % init
    x1  = indep_vars(1);
    x2  = indep_vars(2);
    x3  = indep_vars(3);
    P_1 = [0;-x3;x2];
    P_2 = [x3;0;-x1];
    P_3 = [-x2;x1;0];
    
    if (deg_k==1)
        basis(1).func = P_1;
        basis(2).func = P_2;
        basis(3).func = P_3;
    else % deg_k >= 2
        P_tilde_k_minus_1_basis = basis_polys_deg_k(indep_vars,deg_k-1,true);
        P_tilde_k_minus_2_basis = basis_polys_deg_k(indep_vars,deg_k-2,true);
        % init
        V1  = P_tilde_k_minus_1_basis;
        V2  = P_tilde_k_minus_1_basis;
        
        Num_Basis_W3 = length(P_tilde_k_minus_1_basis) - length(P_tilde_k_minus_2_basis);
        W3(Num_Basis_W3).func = []; % init
        
        bi = 0; % init index counter
        for ii = 1:length(P_tilde_k_minus_1_basis)
            KEEP = true;
            current_basis_func = P_tilde_k_minus_1_basis(ii).func;
            for jj = 1:length(P_tilde_k_minus_2_basis)
                other_func = P_tilde_k_minus_2_basis(jj).func * x3;
                if (current_basis_func==other_func)
                    KEEP = false; % remove!
                    break;
                end
            end
            if (KEEP)
                bi = bi + 1;
                W3(bi).func = current_basis_func;
            end
        end
        if (Num_Basis_W3~=length(W3))
            error('Invalid!  Number of basis functions is incorrect!');
        end
        
        num_basis_check = length(V1) + length(V2) + length(W3);
        if (num_basis_check~=num_basis)
            error('Invalid!  Number of basis functions is incorrect!');
        end
        
        % multiply other terms
        for ii = 1:length(V1)
            V1(ii).func = V1(ii).func * P_1;
            V2(ii).func = V2(ii).func * P_2;
        end
        for ii = 1:length(W3)
            W3(ii).func = W3(ii).func * P_3;
        end
        
        basis = [V1, V2, W3]; % collect them all and output
    end
else
    error('Not implemented!');
end

end