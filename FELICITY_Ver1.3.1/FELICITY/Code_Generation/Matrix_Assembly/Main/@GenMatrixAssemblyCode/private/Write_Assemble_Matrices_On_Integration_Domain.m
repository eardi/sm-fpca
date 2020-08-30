function Write_Assemble_Matrices_On_Integration_Domain(fid,FS,FM,Integration_Index)
%Write_Assemble_Matrices_On_Integration_Domain
%
%   This generates a subroutine in the file: "Generic_FEM_Assembly.cc".

% Copyright (c) 06-16-2016,  Shawn W. Walker

DoI_GeomFunc = FS.Integration(Integration_Index).DoI_Geom;
DoI = DoI_GeomFunc.Domain;
CPP_DoI = DoI.Determine_CPP_Info;
% generate a unique list of GeomFuncs on the current domain of integration
GeomFunc = FS.Get_Unique_Array_Of_GeomFuncs(Integration_Index);

ENDL = '\n';
TAB = '    ';
TAB2 = [TAB, TAB];
TAB3 = [TAB, TAB, TAB];
%%%%%%%
DoI_Name_str = FS.Integration(Integration_Index).DoI_Geom.Domain.Integration_Domain.Name;
Assemble_Domain_STR = ['assemble matrices over the Integration Domain: ', DoI_Name_str];
fprintf(fid, [TAB, '// BEGIN: ', Assemble_Domain_STR, ENDL]);
%fprintf(fid, [TAB, 'Num_DoI_Elem = ', CPP_DoI.Identifier_Name, '.Get_Num_Elem();', ENDL]);
%fprintf(fid, [TAB, 'mexPrintf("Num_DoI_Elem = %%d.\\n",Num_DoI_Elem);', ENDL]);

fprintf(fid, ['', ENDL]);
fprintf(fid, [TAB, 'if (', CPP_DoI.Identifier_Name, '.Sub_Assem_List.empty())', ENDL]);
fprintf(fid, [TAB2, '{', ENDL]);
fprintf(fid, [TAB2, 'mexPrintf("This integration domain is empty: ', DoI_Name_str, '\\n"', ');', ENDL]);
fprintf(fid, [TAB2, 'mexPrintf(" ... so no assembly necessary.\\n");', ENDL]);
fprintf(fid, [TAB2, '}', ENDL]);
fprintf(fid, ['', ENDL]);

fprintf(fid, [TAB, '// loop through each element', ENDL]);
%fprintf(fid, [TAB, 'for (unsigned int DoI_Index = 0; DoI_Index < Num_DoI_Elem; DoI_Index++)', ENDL]);
fprintf(fid, [TAB, 'for (std::vector<unsigned int>::iterator DoI_Ind = ', CPP_DoI.Identifier_Name, '.Sub_Assem_List.begin();', ENDL]);
fprintf(fid, [TAB, '          DoI_Ind != ', CPP_DoI.Identifier_Name, '.Sub_Assem_List.end(); ++DoI_Ind)', ENDL]);
fprintf(fid, [TAB2, '{', ENDL]);
% read in the embedding data
for gi = 1:length(GeomFunc)
    Current_Domain = GeomFunc{gi}.Domain;
    CPP_Domain = Current_Domain.Determine_CPP_Info;
    fprintf(fid, [TAB2, CPP_Domain.Identifier_Name, '.Read_Embed_Data(*DoI_Ind);', ENDL]);
    %fprintf(fid, [TAB2, 'mexPrintf("Global_Cell_Index = %%d.\\n",', CPP_Domain.Identifier_Name, '.Global_Cell_Index + 1', ');', ENDL]);
end
fprintf(fid, ['', ENDL]);

fprintf(fid, [TAB2, '// get the local simplex transformation', ENDL]);
for gi = 1:length(GeomFunc)
    Mesh_Name_str = GeomFunc{gi}.CPP.Identifier_Name;
    fprintf(fid, [TAB2, Mesh_Name_str, '.Compute_Local_Transformation();', ENDL]);
end
fprintf(fid, ['', ENDL]);

% EXAMPLE:
%%%%%%%
%         /*------------ BEGIN: Auto Generate ------------*/
%         // perform pre-computations with FEM basis functions
%         Basis_FEM_phi_0.Map_Gradient_Of_Basis_Function(Mesh);
%         /*------------   END: Auto Generate ------------*/
BF_Set = FS.Integration(Integration_Index).BasisFunc;
Basis_Func = BF_Set.values;
if ~isempty(Basis_Func)
    %%%%%%%
    % output text-lines
    fprintf(fid, ['        ', '// perform pre-computations with FE basis functions', ENDL]);
    fprintf(fid, ['        ', '// NOTE: this must come before the external FE coefficient functions', ENDL]);
    for index = 1:length(Basis_Func)
        Func_Call_str = [Basis_Func{index}.CPP_Var, '.Transform_Basis_Functions();'];
        fprintf(fid, ['        ', Func_Call_str, ENDL]);
    end
    fprintf(fid, ['', ENDL]);
    %%%%%%%
end

% EXAMPLE:
%%%%%%%
%         /*------------ BEGIN: Auto Generate ------------*/
%         // perform pre-computations with external FEM functions
%         Ext_FEM_Func_0.Compute_Func(Elem_Index, Mesh);
%         /*------------   END: Auto Generate ------------*/
CF_Set = FS.Integration(Integration_Index).CoefFunc;
Coef_Func = CF_Set.values;
if ~isempty(Coef_Func)
    %%%%%%%
    % output text-lines
    fprintf(fid, ['        ', '// perform pre-computations with external FE coefficient functions', ENDL]);
    for index = 1:length(Coef_Func)
        Func_Call_str = [Coef_Func{index}.CPP_Var, '.Compute_Func();'];
        fprintf(fid, ['        ', Func_Call_str, ENDL]);
    end
    %%%%%%%
end

fprintf(fid, ['', ENDL]);
fprintf(fid, [TAB2, '// loop through the FE matrices to compute', ENDL]);

FM_Int_Index = FM.Get_Integration_Index(DoI.Integration_Domain);
Matrix_Names = FM.Integration(FM_Int_Index).Matrix.keys; % on the current DoI
NUM_MAT = length(Matrix_Names);
for mi = 1:NUM_MAT
    MAT_CPP = FM.Get_Matrix_CPP_Info(Matrix_Names{mi});
    fprintf(fid, [TAB2, MAT_CPP.Base_Var_Name, '->Tabulate_Tensor(',...
                        DoI_GeomFunc.CPP.Identifier_Name, ');', ENDL]);
end

fprintf(fid, ['', ENDL]);
fprintf(fid, [TAB2, '// loop through the block FE matrices to assemble', ENDL]);

FM_Int_Index = FM.Get_Integration_Index(DoI.Integration_Domain);
Matrix_Names = FM.Integration(FM_Int_Index).Matrix.keys; % on the current DoI
NUM_MAT = length(Matrix_Names);
for mi = 1:NUM_MAT
    MAT_CPP = FM.Get_Matrix_CPP_Info(Matrix_Names{mi});
    Num_Blocks = 1;
    [~, Function_Call_Std_str] = Get_Assemble_Matrix_Call(Num_Blocks,MAT_CPP,DoI_GeomFunc);
    fprintf(fid, [TAB2, MAT_CPP.Block_Assemble_Var_Name, '->', Function_Call_Std_str, ';', ENDL]);
end

fprintf(fid, [TAB2, '}', ENDL]);
fprintf(fid, [TAB, '// END: ', Assemble_Domain_STR, ENDL]);
fprintf(fid, ['', ENDL]);

end