function eofile = Elem_DoF_Allocator_end_of_file(obj)
%Elem_DoF_Allocator_end_of_file
%
%   This stores lines of code for sub-sections of the
%   'Elem_DoF_Allocator.cc' C++ code file.

% Copyright (c) 10-14-2016,  Shawn W. Walker

%%%%%%%
eofile = FELtext('end-of-file');
%%%
eofile = eofile.Append_CR('#undef ELEM_Name');
eofile = eofile.Append_CR('#undef EDA');
eofile = eofile.Append_CR('#undef NODAL_TOPOLOGY');
eofile = eofile.Append_CR('#undef SINGLE_EDGE_PERM_MAP');
eofile = eofile.Append_CR('#undef EDGE_DOF_PERMUTATION');
eofile = eofile.Append_CR('#undef SINGLE_FACE_PERM_MAP');
eofile = eofile.Append_CR('#undef FACE_DOF_PERMUTATION');
eofile = eofile.Append_CR('#undef Dimension');
eofile = eofile.Append_CR('#undef Domain_str');
eofile = eofile.Append_CR('');
eofile = eofile.Append_CR('#undef NUM_VTX');
eofile = eofile.Append_CR('#undef NUM_EDGE');
eofile = eofile.Append_CR('#undef NUM_FACE');
eofile = eofile.Append_CR('#undef NUM_TET');
eofile = eofile.Append_CR('');
eofile = eofile.Append_CR('#undef Num_Vtx_Sets');
eofile = eofile.Append_CR('#undef Num_Edge_Sets');
eofile = eofile.Append_CR('#undef Num_Face_Sets');
eofile = eofile.Append_CR('#undef Num_Tet_Sets');
eofile = eofile.Append_CR('');
eofile = eofile.Append_CR('#undef Max_DoF_Per_Vtx');
eofile = eofile.Append_CR('#undef Max_DoF_Per_Edge');
eofile = eofile.Append_CR('#undef Max_DoF_Per_Face');
eofile = eofile.Append_CR('#undef Max_DoF_Per_Tet');
eofile = eofile.Append_CR('');
eofile = eofile.Append_CR('#undef Num_DoF_Per_Vtx');
eofile = eofile.Append_CR('#undef Num_DoF_Per_Edge');
eofile = eofile.Append_CR('#undef Num_DoF_Per_Face');
eofile = eofile.Append_CR('#undef Num_DoF_Per_Tet');
eofile = eofile.Append_CR('');
eofile = eofile.Append_CR('#undef Total_DoF_Per_Cell');
eofile = eofile.Append_CR('');
eofile = eofile.Append_CR('/***/');

end