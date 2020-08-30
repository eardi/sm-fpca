function SPACE = Get_CPPdefine_Space_Name(obj,Space_Name)
%Get_CPPdefine_Space_Name
%
%   This returns a struct containing CPP mex name info for the given FE Space.

% Copyright (c) 06-23-2012,  Shawn W. Walker

[TF, LOC] = ismember(Space_Name,obj.Space.keys);
if ~TF
    error('Given Space_Name does not exist!');
end

SPACE.Node_Value = [Space_Name, '_Values'];
SPACE.DoFmap     = [Space_Name, '_DoFmap'];
SPACE.MEX_DoFmap = ['PRHS_', SPACE.DoFmap];

end