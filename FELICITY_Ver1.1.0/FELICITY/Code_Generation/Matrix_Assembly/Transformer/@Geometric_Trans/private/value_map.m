function obj = value_map(obj)
%value_map
%
%   Get the value map, i.e. direct evaluation of PHI.

% Copyright (c) 02-20-2012,  Shawn W. Walker

% create the main map
if (obj.GeoDim==1)
    obj.PHI.Val = sym('[PHI_1]');
elseif (obj.GeoDim==2)
    obj.PHI.Val = sym('[PHI_1; PHI_2]');
elseif (obj.GeoDim==3)
    obj.PHI.Val = sym('[PHI_1; PHI_2; PHI_3]');
end

end