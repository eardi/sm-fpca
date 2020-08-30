function domain_defines = Elem_DoF_Allocator_domain_defines(obj,Elem)
%Elem_DoF_Allocator_domain_defines
%
%   This stores lines of code for sub-sections of the
%   'Elem_DoF_Allocator.cc' C++ code file.

% Copyright (c) 12-10-2010,  Shawn W. Walker

% get number of DoF's per topological entity.
Domain = Get_Domain_Info(Elem);

% /*------------ BEGIN: Auto Generate ------------*/
% // set (intrinsic) dimension and domain
% #define Dimension    2
% #define Domain_str  "triangle"
% 
% // set the number of vertices
% #define NUM_VTX    3
% // set the number of edges
% #define NUM_EDGE   3
% // set the number of faces
% #define NUM_FACE   1
% // set the number of tetrahedrons
% #define NUM_TET    0
% /*------------   END: Auto Generate ------------*/

%%%%%%%
domain_defines = FELtext('domain #defines');
% store text-lines
domain_defines = domain_defines.Append_CR(obj.String.BEGIN_Auto_Gen);
domain_defines = domain_defines.Append_CR('// set (intrinsic) dimension and domain');
domain_defines = domain_defines.Append_CR(['#define Dimension    ', num2str(Elem.Dim)]);
domain_defines = domain_defines.Append_CR(['#define Domain_str  "', Elem.Domain, '"']);
domain_defines = domain_defines.Append_CR('');
domain_defines = domain_defines.Append_CR('// set the number of vertices');
domain_defines = domain_defines.Append_CR(['#define NUM_VTX    ', num2str(Domain.Num_Vtx)]);
domain_defines = domain_defines.Append_CR('// set the number of edges');
domain_defines = domain_defines.Append_CR(['#define NUM_EDGE   ', num2str(Domain.Num_Edge)]);
domain_defines = domain_defines.Append_CR('// set the number of faces');
domain_defines = domain_defines.Append_CR(['#define NUM_FACE   ', num2str(Domain.Num_Face)]);
domain_defines = domain_defines.Append_CR('// set the number of tetrahedrons');
domain_defines = domain_defines.Append_CR(['#define NUM_TET    ', num2str(Domain.Num_Tet)]);
domain_defines = domain_defines.Append_CR(obj.String.END_Auto_Gen);
domain_defines = domain_defines.Append_CR('');

end