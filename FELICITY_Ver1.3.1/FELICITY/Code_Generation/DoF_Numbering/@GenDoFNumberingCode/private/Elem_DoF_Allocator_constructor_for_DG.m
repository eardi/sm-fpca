function cons = Elem_DoF_Allocator_constructor_for_DG(obj)
%Elem_DoF_Allocator_constructor_for_DG
%
%   This stores lines of code for sub-sections of the
%   'Elem_DoF_Allocator.cc' C++ code file.

% Copyright (c) 12-01-2010,  Shawn W. Walker

%     // setup
%     Name              = (char *) ELEM_Name;
%     Dim               = Dimension;
%     Domain            = (char *) Domain_str;

%%%%%%%
cons = FELtext('constructor');
%%%
cons = cons.Append_CR(obj.String.Separator);
cons = cons.Append_CR('/* constructor */');
cons = cons.Append_CR('EDA::EDA ()');
cons = cons.Append_CR('{');
cons = cons.Append_CR('    // setup');
cons = cons.Append_CR('    Name              = (char *) ELEM_Name;');
cons = cons.Append_CR('    Dim               = Dimension;');
cons = cons.Append_CR('    Domain            = (char *) Domain_str;');
cons = cons.Append_CR('}');
cons = cons.Append_CR(obj.String.Separator);
cons = cons.Append_CR('');
cons = cons.Append_CR('');

end