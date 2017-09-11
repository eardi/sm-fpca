function Cell_BC = Lift_Barycentric_Coord_to_Enclosing_Cell(obj,Mesh,Sub_BC,Local_Sub_Indices)
%Lift_Barycentric_Coord_to_Enclosing_Cell
%
%   This translates barycentric coordinates from some lower dimensional mesh
%   entities to barycentric coordinates for the higher dimensional enclosing
%   cell.
%
%   Cell_BC = obj.Lift_Barycentric_Coord_to_Enclosing_Cell(Mesh,Sub_BC,Local_Sub_Indices);
%
%   Mesh = (FELICITY mesh) this is the mesh that the FE space is defined on.
%   Sub_BC = array of barycentric coordinates with respect to the elements of a
%            subdomain of the mesh.
%   Local_Sub_Indices = local topological entity indices (w.r.t. the enclosing
%                       cell) that represent the subdomain.
%
%   Cell_BC = array of barycentric coordinates that are defined with respect to
%             the *enclosing cell* for each element in the subdomain.
%
%   e.g. if [0.3, 0.7] are the barycentric coordinates on an edge, then
%   [0.3, 0, 0.7] would be the barycentric coordinates on the triangle that
%   contains the edge as its local edge (-e2).

% Copyright (c) 04-25-2011,  Shawn W. Walker

if ~isempty(obj.Mesh_Info.SubName)
    if (Mesh.Subdomain(obj.Mesh_Info.SubIndex).Dim==Mesh.Top_Dim)
        % easy case, because each element in the subdomain IS its enclosing cell
        Cell_BC = Sub_BC;
    else
        % it must be a strict sub-domain (i.e. codimension > 0)
        % we want barycentric coordinates relative to the hold-all mesh
        Cell_BC = zeros(size(Sub_BC,1),Mesh.Top_Dim+1); % init
        
        if (Mesh.Subdomain(obj.Mesh_Info.SubIndex).Dim==0)
            Cell_BC = BC_for_Vertices(Cell_BC,Local_Sub_Indices);
            
        elseif (Mesh.Subdomain(obj.Mesh_Info.SubIndex).Dim==1)
            Cell_BC = BC_for_Edges(Cell_BC,Local_Sub_Indices,Sub_BC);
            
        elseif (Mesh.Subdomain(obj.Mesh_Info.SubIndex).Dim==2)
            Cell_BC = BC_for_Faces(Cell_BC,Local_Sub_Indices,Sub_BC);
            
        else
            error('This should not happen!');
        end
    end
else % the subdomain IS the entire mesh
    Cell_BC = Sub_BC;
end

end

function Cell_BC = BC_for_Vertices(Cell_BC,Local_Sub_Indices)

% do each vertex individually
for ind = 1:size(Cell_BC,2)
    MASK = (Local_Sub_Indices == ind);
    Cell_BC(MASK,ind) = 1;
end

end

function Cell_BC = BC_for_Edges(Cell_BC,Local_Sub_Indices,Sub_BC)

Top_Dim = size(Cell_BC,2)-1;

if (Top_Dim==2) % triangle case
    edge.l    = [2 3];
    edge(2).l = [3 1];
    edge(3).l = [1 2];
    for ei = 1:length(edge)
        pos_ei = (Local_Sub_Indices == ei);
        neg_ei = (Local_Sub_Indices == -ei);
        Cell_BC(pos_ei,edge(ei).l)          = Sub_BC(pos_ei,:);
        Cell_BC(neg_ei,edge(ei).l(1,[2 1])) = Sub_BC(neg_ei,:);
    end
    
elseif (Top_Dim==3) % tetra case
    edge.l    = [1 2];
    edge(2).l = [1 3];
    edge(3).l = [1 4];
    edge(4).l = [2 3];
    edge(5).l = [3 4];
    edge(6).l = [4 2];
    for ei = 1:length(edge)
        pos_ei = (Local_Sub_Indices == ei);
        neg_ei = (Local_Sub_Indices == -ei);
        Cell_BC(pos_ei,edge(ei).l)          = Sub_BC(pos_ei,:);
        Cell_BC(neg_ei,edge(ei).l(1,[2 1])) = Sub_BC(neg_ei,:);
    end
    
else
    error('This should not happen!');
end

end

function Cell_BC = BC_for_Faces(Cell_BC,Local_Sub_Indices,Sub_BC)

face.l    = [2 3 4];
face(2).l = [1 4 3];
face(3).l = [1 2 4];
face(4).l = [1 3 2];

for fi = 1:length(face)
    pos_fi = (Local_Sub_Indices == fi);
    neg_fi = (Local_Sub_Indices == -fi);
    Cell_BC(pos_fi,face(fi).l)          = Sub_BC(pos_fi,:);
    Cell_BC(neg_fi,face(fi).l(1,[1 3 2])) = Sub_BC(neg_fi,:);
end

end