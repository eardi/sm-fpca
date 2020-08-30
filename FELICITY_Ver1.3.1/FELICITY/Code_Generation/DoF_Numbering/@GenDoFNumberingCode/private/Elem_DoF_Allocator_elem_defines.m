function [elem_defines, CPP_Data_Type_str] = Elem_DoF_Allocator_elem_defines(obj,Elem)
%Elem_DoF_Allocator_elem_defines
%
%   This stores lines of code for sub-sections of the
%   'Elem_DoF_Allocator.cc' C++ code file.

% Copyright (c) 12-10-2010,  Shawn W. Walker

% get number of DoF's per topological entity.
DoF = Get_DoF_Info(Elem);

% /*------------ BEGIN: Auto Generate ------------*/
% // set the type of element
% #define ELEM_Name        "Elem3_Test"
% // set allocator class name
% #define EDA               Elem3_Test_DoF_Allocator
% // set nodal topology data type name
% #define NODAL_TOPOLOGY    Elem3_Test_nodal_top
% 
% // set the number of DoF sets
% #define Num_Vtx_Sets        2
% #define Num_Edge_Sets       2
% #define Num_Face_Sets       0
% #define Num_Tet_Sets        0
% 
% // set the max number (over all sets) of DoFs per entity per set
% #define Max_DoF_Per_Vtx     1
% #define Max_DoF_Per_Edge    2
% #define Max_DoF_Per_Face    0
% #define Max_DoF_Per_Tet     0
% 
% // set the total number of DoFs per entity
% #define Num_DoF_Per_Vtx     2
% #define Num_DoF_Per_Edge    4
% #define Num_DoF_Per_Face    0
% #define Num_DoF_Per_Tet     0
% 
% // set the TOTAL number of DoFs per cell (element)
% #define Total_DoF_Per_Cell  18
% /*------------   END: Auto Generate ------------*/

%%%%%%%
elem_defines = FELtext('elem #defines');
% store text-lines
elem_defines = elem_defines.Append_CR(obj.String.BEGIN_Auto_Gen);
elem_defines = elem_defines.Append_CR('// set the type of element');
elem_defines = elem_defines.Append_CR(['#define ELEM_Name        "', Elem.Name, '"']);
elem_defines = elem_defines.Append_CR('// set allocator class name');
CPP_Data_Type_str = [Elem.Name, '_DoF_Allocator'];
elem_defines = elem_defines.Append_CR(['#define EDA               ', CPP_Data_Type_str]);
elem_defines = elem_defines.Append_CR('// set nodal topology data type name');
NT_str = [Elem.Name, '_nodal_top'];
elem_defines = elem_defines.Append_CR(['#define NODAL_TOPOLOGY    ', NT_str]);

elem_defines = elem_defines.Append_CR('// set permutation map data type names');
SINGLE_EDGE_PERM_MAP_str = [Elem.Name, '_single_edge_perm_map'];
elem_defines = elem_defines.Append_CR(['#define SINGLE_EDGE_PERM_MAP    ', SINGLE_EDGE_PERM_MAP_str]);
EDGE_DOF_PERMUTATION_str = [Elem.Name, '_edge_dof_perm'];
elem_defines = elem_defines.Append_CR(['#define EDGE_DOF_PERMUTATION    ', EDGE_DOF_PERMUTATION_str]);

SINGLE_FACE_PERM_MAP_str = [Elem.Name, '_single_face_perm_map'];
elem_defines = elem_defines.Append_CR(['#define SINGLE_FACE_PERM_MAP    ', SINGLE_FACE_PERM_MAP_str]);
FACE_DOF_PERMUTATION_str = [Elem.Name, '_face_dof_perm'];
elem_defines = elem_defines.Append_CR(['#define FACE_DOF_PERMUTATION    ', FACE_DOF_PERMUTATION_str]);

elem_defines = elem_defines.Append_CR('');
elem_defines = elem_defines.Append_CR('// set the number of DoF sets');
elem_defines = elem_defines.Append_CR(['#define Num_Vtx_Sets        ', num2str(DoF.V.Num_Set)]);
elem_defines = elem_defines.Append_CR(['#define Num_Edge_Sets       ', num2str(DoF.E.Num_Set)]);
elem_defines = elem_defines.Append_CR(['#define Num_Face_Sets       ', num2str(DoF.F.Num_Set)]);
elem_defines = elem_defines.Append_CR(['#define Num_Tet_Sets        ', num2str(DoF.T.Num_Set)]);
elem_defines = elem_defines.Append_CR('');
elem_defines = elem_defines.Append_CR('// set the max number (over all sets) of DoFs per entity per set');
elem_defines = elem_defines.Append_CR(['#define Max_DoF_Per_Vtx     ', num2str(DoF.V.Max_DoF_Per_Set)]);
elem_defines = elem_defines.Append_CR(['#define Max_DoF_Per_Edge    ', num2str(DoF.E.Max_DoF_Per_Set)]);
elem_defines = elem_defines.Append_CR(['#define Max_DoF_Per_Face    ', num2str(DoF.F.Max_DoF_Per_Set)]);
elem_defines = elem_defines.Append_CR(['#define Max_DoF_Per_Tet     ', num2str(DoF.T.Max_DoF_Per_Set)]);
elem_defines = elem_defines.Append_CR('');
elem_defines = elem_defines.Append_CR('// set the total number of DoFs per entity');
elem_defines = elem_defines.Append_CR(['#define Num_DoF_Per_Vtx     ', num2str(DoF.V.Num_DoF)]);
elem_defines = elem_defines.Append_CR(['#define Num_DoF_Per_Edge    ', num2str(DoF.E.Num_DoF)]);
elem_defines = elem_defines.Append_CR(['#define Num_DoF_Per_Face    ', num2str(DoF.F.Num_DoF)]);
elem_defines = elem_defines.Append_CR(['#define Num_DoF_Per_Tet     ', num2str(DoF.T.Num_DoF)]);
elem_defines = elem_defines.Append_CR('');
elem_defines = elem_defines.Append_CR('// set the TOTAL number of DoFs per cell (element)');
elem_defines = elem_defines.Append_CR(['#define Total_DoF_Per_Cell  ', num2str(DoF.Total)]);
elem_defines = elem_defines.Append_CR(obj.String.END_Auto_Gen);
elem_defines = elem_defines.Append_CR('');

end