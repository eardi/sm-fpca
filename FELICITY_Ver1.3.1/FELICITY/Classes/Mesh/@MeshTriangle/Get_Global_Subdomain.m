function Global_Sub = Get_Global_Subdomain(obj,SubName)
%Get_Global_Subdomain
%
%   This returns the sub-domain mesh without embedding it into reference cells.
%
%   Global_Sub = obj.Get_Global_Subdomain(SubName);
%
%   SubName = (string) name of the subdomain.
%
%   Global_Sub = matrix representing subdomain mesh connectivity that indexes
%                into obj.Points.  This is just like the 'SubData' input of
%                'Append_Subdomain'.
%   For example:
%       0-D Subdomain - output is a Vx1 array of (global) vertex indices, where
%                       each row represents a single vertex.
%       1-D Subdomain - output is a Ex2 array of (global) vertex indices, where
%                       each row represents a single edge.
%       2-D Subdomain - output is a Tx3 array of (global) vertex indices, where
%                       each row represents a single triangle (cell).

% Copyright (c) 09-16-2011,  Shawn W. Walker

Sub_Index = obj.Get_Subdomain_Index(SubName);
if (Sub_Index <= 0)
    disp(['This subdomain was not found: ''', SubName, '''']);
    error('Check that your subdomain exists!');
end

if (obj.Subdomain(Sub_Index).Dim==0)
    Global_Sub = obj.Get_Subdomain_Vertex_List(obj.Subdomain(Sub_Index));
elseif (obj.Subdomain(Sub_Index).Dim==1)
    Global_Sub = obj.Get_Subdomain_Edge_List(obj.Subdomain(Sub_Index));
elseif (obj.Subdomain(Sub_Index).Dim==2)
    Global_Sub = obj.Get_Subdomain_Tri_List(obj.Subdomain(Sub_Index));
else
    error('Dimension is not valid!');
end

end