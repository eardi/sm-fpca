function Premap_Transformation = Get_Premap_Transformation(obj,Elem)
%Get_Premap_Transformation
%
%   This sets up the code for the "pre-map" transformation for H(curl)
%   elements.

% Copyright (c) 10-20-2016,  Shawn W. Walker

% setup output type
TD = obj.GeoMap.TopDim;
GD = obj.GeoMap.GeoDim;

if (TD~=GD)
    error('Not implemented or invalid!');
end
if (TD==2)
    Premap_Transformation = Premap_Transformation_in_2D(obj,Elem);
elseif (TD==3)
    Premap_Transformation = Premap_Transformation_in_3D(obj);
else
    error('Not implemented!');
end

end