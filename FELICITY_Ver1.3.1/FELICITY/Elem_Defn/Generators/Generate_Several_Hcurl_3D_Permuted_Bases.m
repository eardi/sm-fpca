function status = Generate_Several_Hcurl_3D_Permuted_Bases()
%Generate_Several_Hcurl_3D_Permuted_Bases
%
%   This generates permutations of 3-D H(curl) elements of various degrees.
%   This is necessary because 3-D H(curl) is a PITA!

% Copyright (c) 11-04-2016,  Shawn W. Walker

status = 0;

% setup the output directory
PATH = fileparts(mfilename('fullpath'));
parts = strsplit(PATH, filesep);
DirPart = parts(1:end-1);
Output_Dir = strjoin(DirPart, filesep);
Output_Dir = [Output_Dir, filesep];

% collect all Nedelec 1st-kind elements
Master_Elem    = nedelec_1stkind_deg1_dim3();
Master_Elem(2) = nedelec_1stkind_deg2_dim3();
Master_Elem(3) = nedelec_1stkind_deg3_dim3();

% loop through all Nedelec 1st-kind elements
for ii = 1:length(Master_Elem)
    % get permutation map for Nedelec 1st-kind
    Cell = tetrahedron_parameterizations();
    Permute_NV = @(DoF_Perm,Perm_Tet,Sym_Perm_Map,Jacobian_Matrix) ...
                    Permute_Nedelec_1stKind_On_Simplex_Nodal_Variables(Cell,DoF_Perm,Perm_Tet,...
                            Sym_Perm_Map,Jacobian_Matrix,Master_Elem(ii).Nodal_Var);
    %
    Perm_Basis = Generate_Hcurl_3D_Permuted_Basis_Set(Master_Elem(ii),Permute_NV);
    
    % setup filename
    FuncName = [Master_Elem(ii).Name, '_permutation_set'];
    Output_FileName = fullfile(Output_Dir, [FuncName, '.mat']);
    
    % save it!
    save(Output_FileName,'Perm_Basis');
end

% collect all Nedelec 2nd-kind elements..........


end