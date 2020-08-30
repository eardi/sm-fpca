function BF_str = write_element_file_basis_func_string(BF)
%write_element_file_basis_func_string
%
%   This creates a string representing the given symbolic basis function.
%   Note: vector components are separated by ";".
%   Note: matrix rows are separated by ";".

% Copyright (c) 03-22-2018,  Shawn W. Walker

% get dimensions
[NR, NC] = size(BF);

if (NC==1)
    % vector case
    Num_Comp = NR;
    BF_str = []; % init
    for kk = 1:Num_Comp-1
        BF_comp_str = char(BF(kk));
        BF_str = [BF_str, '''', BF_comp_str, '''; '];
    end
    BF_comp_str = char(BF(end));
    BF_str = [BF_str, '''', BF_comp_str, ''''];
else
    % matrix case
    
    %ENDL = '\n';
    BF_str = []; % init
    for rr = 1:NR
        for cc = 1:NC-1
            BF_comp_str = char(BF(rr,cc));
            BF_str = [BF_str, '''', BF_comp_str, ''', '];
        end
        BF_comp_str = char(BF(rr,NC));
        BF_str = [BF_str, '''', BF_comp_str, ''''];
        if (rr < NR)
            BF_str = [BF_str, '; '];
        end
    end
end

end