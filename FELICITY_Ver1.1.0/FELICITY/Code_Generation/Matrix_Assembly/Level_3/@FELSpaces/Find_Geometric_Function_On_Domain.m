function GeoFunc = Find_Geometric_Function_On_Domain(obj,Given_Integration_Domain)
%Find_Geometric_Function_On_Domain
%
%   This returns a GeometricElementFunction.

% Copyright (c) 06-18-2012,  Shawn W. Walker

Int_Index = obj.Get_Integration_Index(Given_Integration_Domain);
GeoFunc = obj.Integration(Int_Index).DoI_Geom;

end