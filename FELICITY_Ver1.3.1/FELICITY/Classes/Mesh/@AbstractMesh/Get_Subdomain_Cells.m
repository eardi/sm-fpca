function Cell_Indices = Get_Subdomain_Cells(obj,SubName)
%Get_Subdomain_Cells
%
%   This routine returns an array of cell indices where each cell index
%   points to a mesh cell that contains an element of the given subdomain.
%
%   Cell_Indices = obj.Get_Subdomain_Cells(SubName);
%
%   SubName = (string) name of the mesh subdomain.

% Copyright (c) 09-16-2011,  Shawn W. Walker

SUB_Index = obj.Get_Subdomain_Index(SubName);
if (SUB_Index==0)
    STR = ['This subdomain was not found: ''', SubName, '''!'];
    error(STR);
end

Cell_Indices = obj.Subdomain(SUB_Index).Data(:,1);

end