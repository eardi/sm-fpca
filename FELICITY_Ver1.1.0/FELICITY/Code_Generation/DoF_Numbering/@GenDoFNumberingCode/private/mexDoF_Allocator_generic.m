function generic = mexDoF_Allocator_generic(obj)
%mexDoF_Allocator_generic
%
%   This stores lines of code for sub-sections of the
%   'mexDoF_Allocator.cpp' C++ code file.

% Copyright (c) 12-10-2010,  Shawn W. Walker

%%%%%%%
generic = FELtext('generic');
% store text-lines
generic = generic.Append_CR('');
generic = generic.Append_CR('// note: ''prhs'' represents the Right-Hand-Side arguments from MATLAB (inputs)');
generic = generic.Append_CR('//       ''plhs'' represents the  Left-Hand-Side arguments from MATLAB (outputs)');
generic = generic.Append_CR('');
generic = generic.Append_CR('');
generic = generic.Append_CR(obj.String.Separator);
generic = generic.Append_CR('// define the "gateway" function');
generic = generic.Append_CR('void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])');
generic = generic.Append_CR('{');

end