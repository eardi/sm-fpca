function includes = mexDoF_Allocator_includes(obj,mex_strings)
%mexDoF_Allocator_includes
%
%   This stores lines of code for sub-sections of the
%   'mexDoF_Allocator.cpp' C++ code file.

% Copyright (c) 12-10-2010,  Shawn W. Walker

% /* include classes and other sub-routines */
% #include "Misc_Files.h"
% #include "Triangle_Edge_Search.cc"
% #include "Elem3_Test_DoF_Allocator.cc"

%%%%%%%
includes = FELtext('#includes');
% store text-lines
includes = includes.Append_CR('/* include classes and other sub-routines */');
includes = includes.Append_CR('#include "Misc_Files.h"');
for ind=1:length(mex_strings.INCLUDE)
    includes = includes.Append_CR(mex_strings.INCLUDE(ind).str);
end
includes = includes.Append_CR('');

end