function IS_CURVED = Set_Expression_Domain_Geometry(GeoElem)
%Set_Expression_Domain_Geometry
%
%   This creates an intermediate struct.

% Copyright (c) 01-28-2013,  Shawn W. Walker

Hold_All_Domain_Top_Dim = GeoElem.Domain.Top_Dim;

if Hold_All_Domain_Top_Dim==1
    if strcmp(GeoElem.Elem.Name,'lagrange_deg1_dim1')
        IS_CURVED = false;
    else
        IS_CURVED = true;
    end
elseif Hold_All_Domain_Top_Dim==2
    if strcmp(GeoElem.Elem.Name,'lagrange_deg1_dim2')
        IS_CURVED = false;
    else
        IS_CURVED = true;
    end
elseif Hold_All_Domain_Top_Dim==3
    if strcmp(GeoElem.Elem.Name,'lagrange_deg1_dim3')
        IS_CURVED = false;
    else
        IS_CURVED = true;
    end
else
    error('Invalid!');
end

end