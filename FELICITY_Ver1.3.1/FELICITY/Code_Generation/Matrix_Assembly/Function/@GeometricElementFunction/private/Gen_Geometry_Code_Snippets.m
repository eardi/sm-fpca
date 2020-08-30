function [obj, CODE, Orientation_TF] = Gen_Geometry_Code_Snippets(obj)
%Gen_Geometry_Code_Snippets
%
%   This routine determines what quantities need to be computed for the local
%   (geometric) map, and then creates the C++ code snippets that will do the
%   computing!

% Copyright (c) 03-07-2012,  Shawn W. Walker

% ensure we have indicated ALL we need,
% i.e. some quantities depend on others so we must make sure to compute those!
obj.Opt = obj.GeoTrans.Resolve_PHI_Dependencies(obj.Opt);

% generate code snippets and store them in an array of structs
CODE = obj.GeoTrans.Output_PHI_Codes(obj.Opt,obj.Elem.Num_Basis);

if isfield(obj.Opt,'Orientation')
    Orientation_TF = obj.Opt.Orientation;
else
    Orientation_TF = false; % do not need local simplex orientation information
end

end