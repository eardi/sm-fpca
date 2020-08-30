function mex_strings = Get_MEX_Strings(obj,Elem_Alloc)
%Get_MEX_Strings
%
%   This just generates the useful strings for creating the main mex file.

% Copyright (c) 04-07-2010,  Shawn W. Walker

SPACE_LEN = 70;
Num_Elem = length(obj.Elem);

if and((obj.Elem(1).Dim==1),strcmp(obj.Elem(1).Domain,'interval'))
    mex_strings = Get_MEX_Strings_1D_Interval(SPACE_LEN,Num_Elem);
elseif and((obj.Elem(1).Dim==2),strcmp(obj.Elem(1).Domain,'triangle'))
    mex_strings = Get_MEX_Strings_2D_Triangle(SPACE_LEN,Num_Elem);
elseif and((obj.Elem(1).Dim==3),strcmp(obj.Elem(1).Domain,'tetrahedron'))
    mex_strings = Get_MEX_Strings_3D_Tetrahedron(SPACE_LEN,Num_Elem);
else
    error('Not implemented!');
end

% Elem_DoF strings
for ind=1:Num_Elem
    Elem_DoF_str                            = [obj.Elem(ind).Name, '_DoF_Map'];
    mex_strings.PLHS_Elem_DoF(ind).str      = ['PLHS_', Elem_DoF_str];
    mex_strings.PLHS_Elem_DoF(ind).aligned  = [Pad_With_Whitespace(mex_strings.PLHS_Elem_DoF(ind).str,...
                                                                   SPACE_LEN), num2str(ind-1)];
end

% include the specific FEM element DoF allocators
Num_Include = length(mex_strings.INCLUDE);
for ind=1:length(Elem_Alloc)
    mex_strings.INCLUDE(Num_Include+ind).str = ['#include "', Elem_Alloc(ind).CPP_Data_Type_str, '.cc"'];
end

end