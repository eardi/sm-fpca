function eofile = mexDoF_Allocator_end_of_file(obj)
%mexDoF_Allocator_end_of_file
%
%   This stores lines of code for sub-sections of the
%   'mexDoF_Allocator.cpp' C++ code file.

% Copyright (c) 12-10-2010,  Shawn W. Walker

eofile = FELtext('end-of-file');
% store text-lines
eofile = eofile.Append_CR('}');
eofile = eofile.Append_CR('');
eofile = eofile.Append_CR('/***/');

end