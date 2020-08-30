function Multiindex_Deriv = Get_Local_Basis_Multiindex_Deriv(obj,Top_Dim,Largest_Derivative_Order)
%Get_Local_Basis_Multiindex_Deriv
%
%   This returns a matrix containing the derivative orders to compute (in
%   multi-index notation) for the local basis functions.  Inputs are the
%   dimension of the local reference element and the largest derivative
%   order.

% Copyright (c) 09-14-2016,  Shawn W. Walker

Multiindex_Deriv = []; % init

if (Largest_Derivative_Order > 2)
    error('Not implemented!');
end

% define array of derivative orders to compute
Deriv_Order_Array = (0:1:Largest_Derivative_Order)';

for ind = 1:length(Deriv_Order_Array)
    mv = Deriv_Order_Array(ind);
    if mv > 2
        error('Derivatives higher than 2 not implemented!');
    end
    if (mv==0)
        LD = [0 0 0];
    elseif (mv==1)
        if Top_Dim==1
            LD = [1 0 0];
        elseif Top_Dim==2
            LD = [1 0 0; 0 1 0];
        elseif Top_Dim==3
            LD = [1 0 0; 0 1 0; 0 0 1];
        else
            error('Topological dimension must be <= 3.');
        end
    elseif (mv==2)
        if (Top_Dim==1)
            LD = [1 0 0];
            LD = [LD; 2 0 0];
        elseif (Top_Dim==2)
            LD = [1 0 0; 0 1 0];
            LD = [LD; 2 0 0; 1 1 0; 0 2 0];
        elseif (Top_Dim==3)
            LD = [1 0 0; 0 1 0; 0 0 1];
            LD = [LD; 2 0 0; 1 1 0; 1 0 1; 0 2 0; 0 1 1; 0 0 2];
        else
            error('Topological dimension must be <= 3.');
        end
    end
    Multiindex_Deriv = [Multiindex_Deriv; LD];
end

Multiindex_Deriv = unique(Multiindex_Deriv,'rows');

end