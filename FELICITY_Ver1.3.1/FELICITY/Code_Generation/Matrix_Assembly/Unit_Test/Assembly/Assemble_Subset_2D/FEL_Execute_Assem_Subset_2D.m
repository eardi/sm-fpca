function status = FEL_Execute_Assem_Subset_2D()
%FEL_Execute_Assem_Subset_2D
%
%   test FELICITY Auto-Generated Assembly Code

% Copyright (c) 05-07-2019,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

% define 2-D mesh
np = 143;
[Tri, Vtx] =  bcc_triangle_mesh(np,np);
Mesh = MeshTriangle(Tri,Vtx,'Omega');

% DoFmap for FE space (simple)
Vh_DoFmap = uint32(Mesh.ConnectivityList);

disp('Assemble over all elements:');
tic
FEM_normal = UNIT_TEST_mex_Assemble_Subset_2D([],Mesh.Points,uint32(Mesh.ConnectivityList),[],[],Vh_DoFmap);
toc

% break up the assembly into several subsets
Num_Cell = size(Vh_DoFmap,1);
All_Indices = (1:1:Num_Cell)';
Num_Subsets = 24;
Len_Subset = round(Num_Cell/Num_Subsets);

% init
SubElem_List(Num_Subsets).DoI_Name = 'Omega';
SubElem_List(Num_Subsets).Elem_Indices = [];
for kk = 1:Num_Subsets-1
    SubElem_List(kk).DoI_Name = SubElem_List(end).DoI_Name;
    SubElem_List(kk).Elem_Indices = uint32(All_Indices(1 + (kk-1)*Len_Subset:kk*Len_Subset,1));
end
SubElem_List(Num_Subsets).Elem_Indices = uint32(All_Indices(1 + kk*Len_Subset:end,1));

% All_CHK = [SubElem_List(1).Elem_Indices; SubElem_List(2).Elem_Indices; SubElem_List(3).Elem_Indices;];
% max(abs(All_Indices - double(All_CHK)))

% for jj = 1:length(SubElem_List)
%     SubElem_List(jj).DoI_Name
%     SubElem_List(jj).Elem_Indices
% end

%SubElem_List(4).DoI_Name = [];

% % sublist
% SubElem_List.DoI_Name = 'Gamma';
% SubElem_List.Elem_Indices = [];
% SubElem_List(2).DoI_Name = 'Sigma';
% SubElem_List(2).Elem_Indices = [5, 7];
% SubElem_List(3).DoI_Name = 'Omega';
% SubElem_List(3).Elem_Indices = uint32([3, 100, 1, 56, 23]);

ASS(Num_Subsets).FEM = []; % init
% tic
% for kk = 1:Num_Subsets
%     % assemble on subsets
%     %tic
%     ASS(kk).FEM = UNIT_TEST_mex_Assemble_Subset_2D([],Mesh.Points,uint32(Mesh.ConnectivityList),[],[],...
%                                                       Vh_DoFmap,SubElem_List(kk));
%     %toc
% end
% toc

disp(' ');
disp('Assemble on subsets:');
%tic
for kk = 1:Num_Subsets
    % assemble on subsets
    tic
    ASS(kk).FEM = UNIT_TEST_mex_Assemble_Subset_2D(FEM_normal,Mesh.Points,uint32(Mesh.ConnectivityList),[],[],...
                                                      Vh_DoFmap,SubElem_List(kk));
    toc
end
%toc

% RefFEMDataFileName = fullfile(Current_Dir,'FEL_Execute_Assem_Subset_2D_REF_Data.mat');
% % FEM_REF = FEM;
% % save(RefFEMDataFileName,'FEM_REF');
% load(RefFEMDataFileName);

% now add them up!
FEM_total = ASS(1).FEM; % init
for jj = 1:length(FEM_total)
    FEM_total(jj).MAT = 0*FEM_total(jj).MAT;
end
for kk = 1:Num_Subsets
    FEM_sub = ASS(kk).FEM;
    for jj = 1:length(FEM_total)
        FEM_total(jj).MAT = FEM_total(jj).MAT + FEM_sub(jj).MAT;
    end
end

% now compare the different approaches (should give the same matrix)
FEM_CHK = FEM_normal; % init
disp(' ');
disp('The error in performing sub-assembly over several subsets is...')
disp('----------------------------------------');
Num_FEM = length(FEM_total);
ERR_CHK = zeros(Num_FEM,1);
for jj = 1:Num_FEM
    FEM_CHK(jj).MAT = abs(FEM_total(jj).MAT - FEM_normal(jj).MAT);
    disp('Error (should be machine precision):');
    ERR_CHK(jj) = full(max(FEM_CHK(jj).MAT(:)));
    ERR_CHK(jj)
end
disp('----------------------------------------');

% mats = FEMatrixAccessor('sub-assem',FEM_normal);
% M   = mats.Get_Matrix('Mass_Matrix');
% RHS = mats.Get_Matrix('RHS');
% K   = mats.Get_Matrix('Stiff_Matrix');

% disp('Matrix M:');
% size(M)
% nnz(M)
% 
% disp('Matrix K:');
% size(K)
% nnz(K)
% 
% disp('Vector RHS:');
% size(RHS)
% nnz(RHS)

status = 0; % init
for ind = 1:length(ERR_CHK)
    if (ERR_CHK(ind) > 1e-13)
        disp(['Test Failed for FEM(', num2str(ind), ').MAT...']);
        status = 1;
    end
end

end