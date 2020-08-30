function SubMesh = Output_Subdomain_Mesh(obj,SubName)
%Output_Subdomain_Mesh
%
%   This gets a consistent, self-contained, mesh representation of a sub-domain
%   in the mesh.
%
%   SubMesh = obj.Output_Subdomain_Mesh(SubName);
%
%   SubName = (string) name of the mesh subdomain.
%
%   SubMesh = (MeshInterval, MeshTriangle, or MeshTetrahedron) a global mesh
%             representation of the given subdomain.

% Copyright (c) 04-15-2011,  Shawn W. Walker

% if the given sub-domain is the name of the underlying mesh
%    or the name is empty
if or(strcmp(SubName,obj.Name),isempty(SubName))
    % then just return the underlying mesh
    SubMesh = obj;
    return;
end

Global_Sub = obj.Get_Global_Subdomain(SubName);

% now make it compact, i.e. local numbering
VL = unique(Global_Sub(:));
[G2L, L2G] = Create_Global_Local_Index_Mapping(VL, max(VL(:)));
Global_Sub(:) = G2L(Global_Sub(:));
Vtx_Coord = obj.Points(L2G,:);

% final mesh
if (size(Global_Sub,2)==1)
    SubMesh = [];
    disp('ERROR: A set of vertices alone does not make a mesh!');
    disp('  ');
elseif (size(Global_Sub,2)==2)
    SubMesh = MeshInterval(Global_Sub,Vtx_Coord,[SubName, ' sub-mesh of ', obj.Name]);
elseif (size(Global_Sub,2)==3)
    SubMesh = MeshTriangle(Global_Sub,Vtx_Coord,[SubName, ' sub-mesh of ', obj.Name]);
elseif (size(Global_Sub,2)==4)
    SubMesh = MeshTetrahedron(Global_Sub,Vtx_Coord,[SubName, ' sub-mesh of ', obj.Name]);
else
    error('Dimension is not valid!');
end

end