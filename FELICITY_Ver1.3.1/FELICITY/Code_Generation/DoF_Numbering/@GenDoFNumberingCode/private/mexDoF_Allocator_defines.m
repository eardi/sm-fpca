function [defines, mex_strings] = mexDoF_Allocator_defines(obj,Elem_Alloc)
%mexDoF_Allocator_defines
%
%   This stores lines of code for sub-sections of the
%   'mexDoF_Allocator.cpp' C++ code file.

% Copyright (c) 12-10-2010,  Shawn W. Walker

mex_strings = obj.Get_MEX_Strings(Elem_Alloc);

% /*------------ BEGIN: Auto Generate ------------*/
% // define input indices
% #define PRHS_Tri_List                                     0
% #define PRHS_Edge_List                                    1
% 
% #define PLHS_Elem3_Test_DoF_Map                           0
% #define PLHS_Pos_Edge_to_Tri                              1
% #define PLHS_Neg_Edge_to_Tri                              2
% /*------------   END: Auto Generate ------------*/

%%%%%%%
defines = FELtext('#defines');
% store text-lines
defines = defines.Append_CR(obj.String.BEGIN_Auto_Gen);
defines = defines.Append_CR('// define  input indices');
for ind=1:length(mex_strings.PRHS)
    STR = ['#define ', mex_strings.PRHS(ind).aligned];
    defines = defines.Append_CR(STR);
end
defines = defines.Append_CR('');
defines = defines.Append_CR('// define output indices');
for ind=1:length(mex_strings.PLHS_Elem_DoF)
    STR = ['#define ', mex_strings.PLHS_Elem_DoF(ind).aligned];
    defines = defines.Append_CR(STR);
end
% for ind=1:length(mex_strings.PLHS)
%     STR = ['#define ', mex_strings.PLHS(ind).aligned];
%     defines = defines.Append_CR(STR);
% end
defines = defines.Append_CR(obj.String.END_Auto_Gen);
defines = defines.Append_CR('');

end