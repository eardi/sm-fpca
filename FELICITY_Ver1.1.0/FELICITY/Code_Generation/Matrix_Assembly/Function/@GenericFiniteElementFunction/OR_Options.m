function obj = OR_Options(obj,INPUT)
%OR_Options
%
%   This SETS what needs to be computed in the C++ code.  Will be defined by
%   sub-classes.  Here we logical OR the info from the input.

% Copyright (c) 04-10-2010,  Shawn W. Walker

if or(length(obj.Opt) > 1,length(INPUT.Opt) > 1)
    error('Invalid!');
end

% deal with the ``Orientation'' field separately
if and(isfield(INPUT.Opt,'Orientation'),~isfield(obj.Opt,'Orientation'))
    % then make it a field!
    obj.Opt.Orientation = false;
end

% ensure that the options are the same
Fields = fieldnames(INPUT.Opt);
fields_TF = isfield(obj.Opt,Fields);
if (min(fields_TF)~=1)
    error('Invalid option list...');
end

% set all the options
for ind = 1:length(Fields)
    FV = or( obj.Opt.(Fields{ind}), INPUT.Opt.(Fields{ind}) );
    obj.Opt.(Fields{ind}) = FV;
end

end