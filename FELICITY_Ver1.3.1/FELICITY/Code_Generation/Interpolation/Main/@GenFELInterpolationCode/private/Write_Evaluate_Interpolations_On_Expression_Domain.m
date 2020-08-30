function Write_Evaluate_Interpolations_On_Expression_Domain(fid,FS,FI,Interp_Domain)
%Write_Evaluate_Interpolations_On_Expression_Domain
%
%   This generates a subroutine in the file: "Generic_FEM_Interpolation.cc".

% Copyright (c) 01-29-2013,  Shawn W. Walker

Integration_Index = FS.Get_Integration_Index(Interp_Domain);

%DoI_GeomFunc = FS.Integration(Integration_Index).DoI_Geom;
%DoE = DoI_GeomFunc.Domain;
% generate a unique list of GeomFuncs on the current domain of expression
GeomFunc = FS.Get_Unique_Array_Of_GeomFuncs(Integration_Index);

ENDL = '\n';
TAB = '    ';
TAB2 = [TAB, TAB];
TAB3 = [TAB, TAB, TAB];
%%%%%%%
Interp_Domain_STR = ['evaluate interpolations over the Expression Domain: ',...
                        FS.Integration(Integration_Index).DoI_Geom.Domain.Integration_Domain.Name];
fprintf(fid, [TAB, '// BEGIN: ', Interp_Domain_STR, ENDL]);
CPP_DOM = FI.Get_CPPdefine_Domain_Name(Interp_Domain.Name);
fprintf(fid, [TAB, 'Num_DoE_Interp_Pts = ', CPP_DOM.Interp_Data, '.Num_Pts;', ENDL]);
%fprintf(fid, [TAB, 'mexPrintf("Num_DoE_Interp_Pts = %%d.\\n",Num_DoE_Interp_Pts);', ENDL]);
fprintf(fid, [TAB, '// loop through each point', ENDL]);
fprintf(fid, [TAB, 'for (unsigned int DoE_Pt = 0; DoE_Pt < Num_DoE_Interp_Pts; DoE_Pt++)', ENDL]);
fprintf(fid, [TAB2, '{', ENDL]);
fprintf(fid, [TAB2, '// read the DoE *element* index from the interpolation point data', ENDL]);
fprintf(fid, [TAB2, 'const unsigned int DoE_Elem_Index_MATLAB_style = ', CPP_DOM.Interp_Data, '.Cell_Index[DoE_Pt];', ENDL]);
fprintf(fid, [TAB2, 'if (DoE_Elem_Index_MATLAB_style==0) // cell index is INVALID, so ignore!', ENDL]);
fprintf(fid, [TAB3, '{', ENDL]);
fprintf(fid, [TAB3, 'mexPrintf("Interpolation cell index is *invalid* for point index #%%d.\\n",DoE_Pt+1);', ENDL]);
fprintf(fid, [TAB3, 'mexPrintf("    No interpolation will be done at this point!\\n");', ENDL]);
fprintf(fid, [TAB3, '}', ENDL]);

fprintf(fid, [TAB2, 'else // only compute if the cell index is valid!', ENDL]);
fprintf(fid, [TAB3, '{', ENDL]);
fprintf(fid, [TAB3, 'unsigned int DoE_Elem_Index = DoE_Elem_Index_MATLAB_style - 1; // need to offset for C-style indexing', ENDL]);
%fprintf(fid, [TAB3, 'mexPrintf("DoE_Elem_Index = %%d.\\n",', 'DoE_Elem_Index + 1', ');', ENDL]);
% read in the embedding data
for gi = 1:length(GeomFunc)
    Current_Domain = GeomFunc{gi}.Domain;
    CPP_Domain = Current_Domain.Determine_CPP_Info;
    fprintf(fid, [TAB3, CPP_Domain.Identifier_Name, '.Read_Embed_Data(DoE_Elem_Index);', ENDL]);
    %fprintf(fid, [TAB3, 'mexPrintf("Global_Cell_Index = %%d.\\n",', CPP_Domain.Identifier_Name, '.Global_Cell_Index + 1', ');', ENDL]);
end
fprintf(fid, ['', ENDL]);

fprintf(fid, [TAB3, '// get the local simplex transformation', ENDL]);
for gi = 1:length(GeomFunc)
    Mesh_Name_str = GeomFunc{gi}.CPP.Identifier_Name;
    fprintf(fid, [TAB3, '// copy local interpolation coordinates', ENDL]);
    Mesh_Local_Coord_str = [Mesh_Name_str, '.local_coord'];
    fprintf(fid, [TAB3, CPP_DOM.Interp_Data, '.Copy_Local_X(DoE_Pt,', Mesh_Local_Coord_str, ');', ENDL]);
    fprintf(fid, [TAB3, Mesh_Name_str, '.Compute_Local_Transformation();', ENDL]);
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
    fprintf(fid, [TAB3, '// perform pre-computations with FE basis functions', ENDL]);
    fprintf(fid, [TAB3, '// NOTE: this must come before the external FE coefficient functions', ENDL]);
    for index = 1:length(Basis_Func)
        BF_Name_str = Basis_Func{index}.CPP_Var;
        fprintf(fid, [TAB3, '// copy local interpolation coordinates', ENDL]);
        BF_Local_Coord_str = [BF_Name_str, '.local_coord'];
        fprintf(fid, [TAB3, CPP_DOM.Interp_Data, '.Copy_Local_X(DoE_Pt,', BF_Local_Coord_str, ');', ENDL]);
        Func_Call_str = [BF_Name_str, '.Transform_Basis_Functions();'];
        fprintf(fid, [TAB3, Func_Call_str, ENDL]);
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
    fprintf(fid, [TAB3, '// perform pre-computations with external FE coefficient functions', ENDL]);
    for index = 1:length(Coef_Func)
        Func_Call_str = [Coef_Func{index}.CPP_Var, '.Compute_Func();'];
        fprintf(fid, [TAB3, Func_Call_str, ENDL]);
    end
    %%%%%%%
end

fprintf(fid, ['', ENDL]);
fprintf(fid, [TAB3, '// loop through the desired FEM interpolations', ENDL]);

% get the interpolations that are defined on the given Interp_Domain
Interp = FI.Get_Interpolations_On_Domain(Interp_Domain.Name);
NUM_INTERP = length(Interp);
for ind = 1:NUM_INTERP
    CPP = FI.Get_Interpolation_CPP_Info(Interp{ind}.Name);
    fprintf(fid, [TAB3, CPP.Var_Name, '->Eval_All_Interpolations(DoE_Pt);', ENDL]);
end
fprintf(fid, [TAB3, '}', ENDL]);

fprintf(fid, [TAB2, '}', ENDL]);
fprintf(fid, [TAB, '// END: ', Interp_Domain_STR, ENDL]);
fprintf(fid, ['', ENDL]);

end