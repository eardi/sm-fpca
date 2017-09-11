function Local_Deriv = Get_Local_Basis_Deriv_From_Global_Deriv(Top_Dim,Global_Deriv)
%Get_Local_Basis_Deriv_From_Global_Deriv
%
%   This just takes the choice of the global basis derivatives and gets the
%   local basis derivatives that will be needed.

% Copyright (c) 04-07-2010,  Shawn W. Walker

Local_Deriv = [];

for ind = 1:size(Global_Deriv,1)
    mv = max(Global_Deriv(ind,:));
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
    Local_Deriv = [Local_Deriv; LD];
end

Local_Deriv = unique(Local_Deriv,'rows');

end