function obj = OR_Option_Struct(obj,INPUT_Opt)
%OR_Option_Struct
%
%   This SETS what needs to be computed in the C++ code.  Will be defined by
%   sub-classes.  Here we logical OR the info from the input.
%   Note: INPUT_Opt is a single struct.

% Copyright (c) 03-15-2012,  Shawn W. Walker

% error check:
if (length(INPUT_Opt)~=1)
    error('INPUT_Opt must be a single struct!');
end
if (length(obj.Opt) > 1)
    error('Invalid!');
end

% ensure that the options are the same
Fields = fieldnames(INPUT_Opt);
fields_TF = isfield(obj.Opt,Fields);
if (min(fields_TF)~=1)
    error('Invalid option list...');
end

% or the options in
for ind = 1:length(Fields)
    FV = or( obj.Opt.(Fields{ind}), INPUT_Opt.(Fields{ind}) );
    obj.Opt.(Fields{ind}) = FV;
end

end