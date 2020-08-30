function INTERP = Interp_Defn_for_GeoElementSpace_INTERNAL(obj)
%Interp_Defn_for_GeoElementSpace_INTERNAL
%
%   Generic definition file for interpolating a function in the finite
%   element space.

% Copyright (c) 03-26-2018,  Shawn W. Walker

% get geometric dimension
if (length(obj.Num_Comp)==1)
    GeoDim = obj.Num_Comp;
elseif (length(obj.Num_Comp)==2)
    if (obj.Num_Comp(2)~=1)
        error('obj.Num_Comp must have the form [GD, 1].');
    end
    GeoDim = obj.Num_Comp(1);
else
    error('Invalid!');
end

% define domain
Hold_All = Domain(obj.RefElem.Simplex_Type,GeoDim);

% define finite element spaces
Elem_Struct = eval([obj.RefElem.Element_Name, '();']);
GS = Element(Hold_All,Elem_Struct,GeoDim);

% define functions on FE spaces
f = Coef(GS);

% define expressions to interpolate
I_h_f = Interpolate(Hold_All, f.val);

% define geometry representation - Domain, (default piecewise linear)
G_PW_Linear = GeoElement(Hold_All);

% define a set of interpolations to perform
INTERP = Interpolations(G_PW_Linear);

% collect all of the interpolations together
INTERP = INTERP.Append_Interpolation(I_h_f);

end