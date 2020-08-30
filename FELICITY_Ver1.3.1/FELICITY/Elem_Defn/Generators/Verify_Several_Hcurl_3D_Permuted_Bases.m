function status = Verify_Several_Hcurl_3D_Permuted_Bases()
%Verify_Several_Hcurl_3D_Permuted_Bases
%
%   This verifies the output of "Generate_Several_Hcurl_3D_Permuted_Bases".

% Copyright (c) 11-04-2016,  Shawn W. Walker

status = 0; % init

% collect all Nedelec 1st-kind elements
Master_Elem    = nedelec_1stkind_deg1_dim3();
Master_Elem(2) = nedelec_1stkind_deg2_dim3();
Master_Elem(3) = nedelec_1stkind_deg3_dim3();

% loop through all Nedelec 1st-kind elements
for dd = 1:length(Master_Elem)
    % setup filename
    FuncName = [Master_Elem(dd).Name, '_permutation_set'];
    %FileName = fullfile(Output_Dir, [FuncName, '.mat']);
    FileName = [FuncName, '.mat'];
    
    % load it!
    disp(['Load: ', FileName]);
    SS = load(FileName,'Perm_Basis');
    Perm_Basis = SS.Perm_Basis;
    clear SS;
    
    % loop through all permutations
    Num_Perm = length(Perm_Basis);
    for pp = 1:Num_Perm
        disp(['Check permutation #', num2str(pp), ' of ', num2str(Num_Perm)]);
        % generate reference element
        Ref_Elem = ReferenceFiniteElement(Perm_Basis(pp).Elem,1);
        TF = Ref_Elem.Verify_Nodal_Kronecker_Delta_Property();
        if (~TF)
            pp
            disp('This permutation does *not* pass!');
            FileName
            status = 1;
            break;
        end
    end
end

% collect all Nedelec 2nd-kind elements...



end