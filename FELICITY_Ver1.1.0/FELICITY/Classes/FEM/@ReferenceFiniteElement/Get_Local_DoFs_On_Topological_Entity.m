function DoFs_on_Entity = Get_Local_DoFs_On_Topological_Entity(obj,Top_Entity_Dim)
%Get_Local_DoFs_On_Topological_Entity
%
%   This returns information on how the local DoF indices are associated with
%   topological entities of a given dimension.
%
%   DoFs_on_Entity = obj.Get_Local_DoFs_On_Topological_Entity(Top_Entity_Dim);
%
%   Top_Entity_Dim = 0, 1, ..., topological dimension of reference element.
%
%   DoFs_on_Entity = NxQ array that lists which local DoF indices are
%                    associated with topological entities of a given dimension.
%                    N = number of topological entities in the simplex of the
%                        given dimension,
%                    Q = number of DoFs on a single topological entity.
%
%   Ex: suppose the reference simplex is a triangle.  Obviously, it has 3 edges,
%   and 3 vertices.  Then,
%
%   DoFs_on_Entity = obj.Get_Local_DoFs_On_Topological_Entity(0),
%
%   where
%   DoFs_on_Entity = 3 x Q0, with each row corresponding to a vertex, and
%                    row 1 corresponds to local vertex 1, etc...
%
%   if we do this:
%   DoFs_on_Entity = obj.Get_Local_DoFs_On_Topological_Entity(1),
%   then,
%   DoFs_on_Entity = 3 x Q1, with each row corresponding to an edge, and
%                    row 1 corresponds to local edge 1, etc...
%
%   if we do this:
%   DoFs_on_Entity = obj.Get_Local_DoFs_On_Topological_Entity(2),
%   then,
%   DoFs_on_Entity = 1 x Q2, which gives the (internal) DoFs associated with the
%                    triangle.

% Copyright (c) 03-22-2012,  Shawn W. Walker

if (obj.Top_Dim < Top_Entity_Dim)
    error('The dimension of the topological entity cannot be bigger than the topological dimension of the element!');
end

nnt = length(obj.Nodal_Top);
switch obj.Top_Dim
    % consecutively concatenate them together
    case 1 % cell = interval
        if (Top_Entity_Dim==0) % 2 vertices per cell
            NODES_1 = [];
            NODES_2 = [];
            for i1 = 1:nnt
                for i2 = 1:length(obj.Nodal_Top(i1).V)
                    if ~isempty(obj.Nodal_Top(i1).V{i2})
                        NODES_1 = [NODES_1, obj.Nodal_Top(i1).V{i2}(1,:)];
                        NODES_2 = [NODES_2, obj.Nodal_Top(i1).V{i2}(2,:)];
                    end
                end
            end
            Entity = [NODES_1; NODES_2];
        end
        if (Top_Entity_Dim==1) % 1 edge per cell
            NODES_1 = [];
            for i1 = 1:nnt
                for i2 = 1:length(obj.Nodal_Top(i1).E)
                    if ~isempty(obj.Nodal_Top(i1).E{i2})
                        NODES_1 = [NODES_1, obj.Nodal_Top(i1).E{i2}(1,:)];
                    end
                end
            end
            Entity = [NODES_1];
        end
    case 2 % cell = triangle
        if (Top_Entity_Dim==0) % 3 vertices per cell
            NODES_1 = [];
            NODES_2 = [];
            NODES_3 = [];
            % get vertex nodes
            for i1 = 1:nnt
                for i2 = 1:length(obj.Nodal_Top(i1).V)
                    if ~isempty(obj.Nodal_Top(i1).V{i2})
                        NODES_1 = [NODES_1, obj.Nodal_Top(i1).V{i2}(1,:)];
                        NODES_2 = [NODES_2, obj.Nodal_Top(i1).V{i2}(2,:)];
                        NODES_3 = [NODES_3, obj.Nodal_Top(i1).V{i2}(3,:)];
                    end
                end
            end
            Entity = [NODES_1; NODES_2; NODES_3];
        end
        if (Top_Entity_Dim==1) % 3 edges per cell
            NODES_1 = [];
            NODES_2 = [];
            NODES_3 = [];
            % get edge nodes
            for i1 = 1:nnt
                for i2 = 1:length(obj.Nodal_Top(i1).E)
                    if ~isempty(obj.Nodal_Top(i1).E{i2})
                        NODES_1 = [NODES_1, obj.Nodal_Top(i1).E{i2}(1,:)];
                        NODES_2 = [NODES_2, obj.Nodal_Top(i1).E{i2}(2,:)];
                        NODES_3 = [NODES_3, obj.Nodal_Top(i1).E{i2}(3,:)];
                    end
                end
            end
            Entity = [NODES_1; NODES_2; NODES_3];
        end
        if (Top_Entity_Dim==2) % 1 triangle per cell
            NODES_1 = [];
            for i1 = 1:nnt
                for i2 = 1:length(obj.Nodal_Top(i1).F)
                    if ~isempty(obj.Nodal_Top(i1).F{i2})
                        NODES_1 = [NODES_1, obj.Nodal_Top(i1).F{i2}(1,:)];
                    end
                end
            end
            Entity = [NODES_1];
        end
    case 3 % cell = tetrahedron
        if (Top_Entity_Dim==0) % 4 vertices per cell
            NODES_1 = [];
            NODES_2 = [];
            NODES_3 = [];
            NODES_4 = [];
            % get vertex nodes
            for i1 = 1:nnt
                for i2 = 1:length(obj.Nodal_Top(i1).V)
                    if ~isempty(obj.Nodal_Top(i1).V{i2})
                        NODES_1 = [NODES_1, obj.Nodal_Top(i1).V{i2}(1,:)];
                        NODES_2 = [NODES_2, obj.Nodal_Top(i1).V{i2}(2,:)];
                        NODES_3 = [NODES_3, obj.Nodal_Top(i1).V{i2}(3,:)];
                        NODES_4 = [NODES_4, obj.Nodal_Top(i1).V{i2}(4,:)];
                    end
                end
            end
            Entity = [NODES_1; NODES_2; NODES_3; NODES_4];
        end
        if (Top_Entity_Dim==1) % 6 edges per cell
            NODES_1 = [];
            NODES_2 = [];
            NODES_3 = [];
            NODES_4 = [];
            NODES_5 = [];
            NODES_6 = [];
            % get edge nodes
            for i1 = 1:nnt
                for i2 = 1:length(obj.Nodal_Top(i1).E)
                    if ~isempty(obj.Nodal_Top(i1).E{i2})
                        NODES_1 = [NODES_1, obj.Nodal_Top(i1).E{i2}(1,:)];
                        NODES_2 = [NODES_2, obj.Nodal_Top(i1).E{i2}(2,:)];
                        NODES_3 = [NODES_3, obj.Nodal_Top(i1).E{i2}(3,:)];
                        NODES_4 = [NODES_4, obj.Nodal_Top(i1).E{i2}(4,:)];
                        NODES_5 = [NODES_5, obj.Nodal_Top(i1).E{i2}(5,:)];
                        NODES_6 = [NODES_6, obj.Nodal_Top(i1).E{i2}(6,:)];
                    end
                end
            end
            Entity = [NODES_1; NODES_2; NODES_3; NODES_4; NODES_5; NODES_6];
        end
        if (Top_Entity_Dim==2) % 4 triangles per cell
            NODES_1 = [];
            NODES_2 = [];
            NODES_3 = [];
            NODES_4 = [];
            for i1 = 1:nnt
                for i2 = 1:length(obj.Nodal_Top(i1).F)
                    if ~isempty(obj.Nodal_Top(i1).F{i2})
                        NODES_1 = [NODES_1, obj.Nodal_Top(i1).F{i2}(1,:)];
                        NODES_2 = [NODES_2, obj.Nodal_Top(i1).F{i2}(2,:)];
                        NODES_3 = [NODES_3, obj.Nodal_Top(i1).F{i2}(3,:)];
                        NODES_4 = [NODES_4, obj.Nodal_Top(i1).F{i2}(4,:)];
                    end
                end
            end
            Entity = [NODES_1; NODES_2; NODES_3; NODES_4];
        end
        if (Top_Entity_Dim==3) % 1 tetrahedron per cell
            NODES_1 = [];
            for i1 = 1:nnt
                for i2 = 1:length(obj.Nodal_Top(i1).T)
                    if ~isempty(obj.Nodal_Top(i1).T{i2})
                        NODES_1 = [NODES_1, obj.Nodal_Top(i1).T{i2}(1,:)];
                    end
                end
            end
            Entity = [NODES_1];
        end
    otherwise
        error('Not implemented!');
end

% sort each row
DoFs_on_Entity = sort(Entity,2);

end