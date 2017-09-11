function dest = Elem_DoF_Allocator_destructor(obj)
%Elem_DoF_Allocator_destructor
%
%   This stores lines of code for sub-sections of the
%   'Elem_DoF_Allocator.cc' C++ code file.

% Copyright (c) 12-01-2010,  Shawn W. Walker

% /* DE-structor */
% EDA::~EDA ()
% {
% }

%%%%%%%
dest = FELtext('destructor');
%%%
dest = dest.Append_CR(obj.String.Separator);
dest = dest.Append_CR('/* destructor */');
dest = dest.Append_CR('EDA::~EDA ()');
dest = dest.Append_CR('{');
dest = dest.Append_CR('}');
dest = dest.Append_CR(obj.String.Separator);
dest = dest.Append_CR('');
dest = dest.Append_CR('');

end