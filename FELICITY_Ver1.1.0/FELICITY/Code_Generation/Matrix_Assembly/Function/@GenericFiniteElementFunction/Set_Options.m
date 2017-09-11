function obj = Set_Options(obj,INPUT)
%Set_Options
%
%   This SETS what needs to be computed in the C++ code.  Will be defined by
%   sub-classes.

% Copyright (c) 04-10-2010,  Shawn W. Walker

% ensure that the options are the same
fields_TF = isfield(obj.Opt,fieldnames(INPUT.Opt));
if (min(fields_TF)~=1)
    error('Invalid option list...');
end

obj.Opt = INPUT.Opt;

end