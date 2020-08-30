function main = mexDoF_Allocator_main_code(obj,mex_strings,Elem_Alloc)
%mexDoF_Allocator_main_code
%
%   This stores lines of code for sub-sections of the
%   'mexDoF_Allocator.cpp' C++ code file.

% Copyright (c) 12-10-2010,  Shawn W. Walker

if and((obj.Elem(1).Dim==1),strcmp(obj.Elem(1).Domain,'interval'))
    main = obj.mexDoF_Allocator_main_code_1D_Interval(mex_strings,Elem_Alloc);
elseif and((obj.Elem(1).Dim==2),strcmp(obj.Elem(1).Domain,'triangle'))
    main = obj.mexDoF_Allocator_main_code_2D_Triangle(mex_strings,Elem_Alloc);
elseif and((obj.Elem(1).Dim==3),strcmp(obj.Elem(1).Domain,'tetrahedron'))
    main = obj.mexDoF_Allocator_main_code_3D_Tetrahedron(mex_strings,Elem_Alloc);
else
    error('Not implemented!');
end

end