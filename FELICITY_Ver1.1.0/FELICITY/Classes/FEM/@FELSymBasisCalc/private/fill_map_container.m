function SymFunc_MAP = fill_map_container(SymFunc_init,Max_Deriv_Order)
%fill_map_container
%
%   This fills the internal map container with FELSymFunc objects that are
%   derivatives of the base (initial) FELSymFunc object.

% Copyright (c) 02-28-2013,  Shawn W. Walker

if (Max_Deriv_Order < 0)
    error('Invalid derivative order!');
end

SymFunc_MAP = containers.Map; % init

% generate sets of multi-index derivatives
k = (0:1:Max_Deriv_Order)'; % init

Num_Vars = SymFunc_init.input_dim;
for vi = 1:Num_Vars-1
    
    one_vec = ones(size(k,1),1);
    k_temp = repmat(k,Max_Deriv_Order+1,1);
    P = [];
    for ind = 0:Max_Deriv_Order
        P = [P; ind*one_vec];
    end
    k = [P, k_temp];
    
end

% only keep the multi-indices that have a derivative order <= to the max desired order
Deriv_Sum = sum(k,2);
TOTAL_VALID = (Deriv_Sum <= Max_Deriv_Order);
Deriv = k(TOTAL_VALID,:);

% remove the no derivative case
ZERO_MASK = (Deriv_Sum == 0);
Deriv(ZERO_MASK,:) = [];

for ind = 1:size(Deriv,1)
    alpha = Deriv(ind,:);
    key_str = make_alpha_str(alpha);
    Diff_Expr = SymFunc_init.Differentiate(alpha);
    SymFunc_MAP(key_str) = Diff_Expr;
end

end