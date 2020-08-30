function DoFs_on_Entity = Get_Nodes_On_Topological_Entity(obj,Top_Entity_Dim)
%Get_Nodes_On_Topological_Entity
%
%   This returns a rectangular array that specifies the local DoF indices
%   attached to each topological entity of dimension 'Top_Entity_Dim'.
%   Note: the functionality here is a little different from
%         'Get_Local_DoFs_On_Topological_Entity'.
%
%   DoFs_on_Entity = obj.Get_Nodes_On_Topological_Entity(Top_Entity_Dim);
%
%   Top_Entity_Dim = 0, 1, ..., topological dimension of reference element.
%
%   DoFs_on_Entity = NxQ array that lists which DoF indices 'lie along' each
%                    topological entity of a given dimension.
%                    N = number of topological entities in the simplex of the
%                        given dimension,
%                    Q = number of DoFs that 'lie along' a single topological
%                        entity.
%
%   (This is useful for subdomains.)
%
%   Note: each topological entity (of given dim) will include DoFs associated
%   with lower dimensional topological entities which are contained in the
%   original topological entity.  E.g. a local edge of a triangle includes the
%   two end-point vertices of that edge.

% Copyright (c) 04-19-2011,  Shawn W. Walker

if (obj.Top_Dim < Top_Entity_Dim)
    error('The dimension of the local topological entity cannot be bigger than the topological dimension of the element (reference domain)!');
end

%nnt = length(obj.Nodal_Top);
switch obj.Top_Dim
    % consecutively concatenate them together
    case 1 % cell = interval
        if (Top_Entity_Dim==0) % 2 vertices per cell
            NODES = cell(2,1);
            % vertex nodes
            V_IND = [1; 2];
            NODES = get_vertex_nodes(obj,NODES,V_IND);
            DoFs_on_Entity = [NODES{1}; NODES{2}];
        end
        if (Top_Entity_Dim==1) % 1 edge per cell (the edge IS the cell)
            DoFs_on_Entity = (1:1:obj.Num_Basis); % all the DoFs
        end
    case 2 % cell = triangle
        if (Top_Entity_Dim==0) % 3 vertices per cell
            NODES = cell(3,1);
            % vertex nodes
            V_IND = [1; 2; 3];
            NODES = get_vertex_nodes(obj,NODES,V_IND);
            DoFs_on_Entity = [NODES{1}; NODES{2}; NODES{3}];
        end
        if (Top_Entity_Dim==1) % 3 edges per cell (and 2 vertices on each edge)
            NODES = cell(3,1);
            % edge nodes
            E_IND = [1; 2; 3];
            NODES = get_edge_nodes(obj,NODES,E_IND);
            
            % vertex nodes
            V_IND = [2 3; 3 1; 1 2];
            NODES = get_vertex_nodes(obj,NODES,V_IND);
            DoFs_on_Entity = [NODES{1}; NODES{2}; NODES{3}];
        end
        if (Top_Entity_Dim==2) % 1 triangle per cell (the triangle IS the cell)
            DoFs_on_Entity = (1:1:obj.Num_Basis); % all the DoFs
        end
    case 3 % cell = tetrahedron
        if (Top_Entity_Dim==0) % 4 vertices per cell
            NODES = cell(4,1);
            % vertex nodes
            V_IND = [1; 2; 3; 4];
            NODES = get_vertex_nodes(obj,NODES,V_IND);
            DoFs_on_Entity = [NODES{1}; NODES{2}; NODES{3}; NODES{4}];
        end
        if (Top_Entity_Dim==1) % 6 edges per cell (and 2 vertices on each edge)
            NODES = cell(6,1);
            % edge nodes
            E_IND = [1; 2; 3; 4; 5; 6];
            NODES = get_edge_nodes(obj,NODES,E_IND);
            
            % vertex nodes
            V_IND = [1 2; 1 3; 1 4; 2 3; 3 4; 4 2];
            NODES = get_vertex_nodes(obj,NODES,V_IND);
            DoFs_on_Entity = [NODES{1}; NODES{2}; NODES{3}; NODES{4}; NODES{5}; NODES{6}];
        end
        if (Top_Entity_Dim==2) % 4 triangles per cell (and 3 edges per triangle and 3 vertices per triangle)
            NODES = cell(4,1);
            % face nodes
            F_IND = [1; 2; 3; 4];
            NODES = get_face_nodes(obj,NODES,F_IND);
            
            % edge nodes
            E_IND = [5 6 4; 5 2 3; 6 3 1; 4 1 2];
            NODES = get_edge_nodes(obj,NODES,E_IND);
            
            % vertex nodes
            V_IND = [2 3 4; 1 4 3; 1 2 4; 1 3 2];
            NODES = get_vertex_nodes(obj,NODES,V_IND);
            DoFs_on_Entity = [NODES{1}; NODES{2}; NODES{3}; NODES{4}];
        end
        if (Top_Entity_Dim==3) % 1 tet per cell (the tet IS the cell)
            DoFs_on_Entity = (1:1:obj.Num_Basis); % all the DoFs
        end
    otherwise
        error('Invalid!');
end

% sort each row
DoFs_on_Entity = sort(DoFs_on_Entity,2);

end

function NODES = get_vertex_nodes(obj,NODES,V_IND)
%
% NODES has length R
% V_IND has size RxC
% C > 1 if there are multiple vertices attached to the entity

Num_V = size(V_IND,1);
nnt = length(obj.Nodal_Top);

% get vertex nodes
for i1 = 1:nnt
    for i2 = 1:length(obj.Nodal_Top(i1).V)
        if ~isempty(obj.Nodal_Top(i1).V{i2})
            for vi = 1:Num_V
                Next_V = obj.Nodal_Top(i1).V{i2}(V_IND(vi,:),:);
                NODES{vi} = [NODES{vi}, Next_V(:)']; % must be a row vector
            end
        end
    end
end

end

function NODES = get_edge_nodes(obj,NODES,E_IND)
%
% NODES has length R
% E_IND has size RxC
% C > 1 if there are multiple edges attached to the entity

Num_E = size(E_IND,1);
nnt = length(obj.Nodal_Top);

% get edge nodes
for i1 = 1:nnt
    for i2 = 1:length(obj.Nodal_Top(i1).E)
        if ~isempty(obj.Nodal_Top(i1).E{i2})
            for ei = 1:Num_E
                Next_E = obj.Nodal_Top(i1).E{i2}(E_IND(ei,:),:);
                NODES{ei} = [NODES{ei}, Next_E(:)']; % must be a row vector
            end
        end
    end
end

end

function NODES = get_face_nodes(obj,NODES,F_IND)
%
% NODES has length R
% F_IND has size RxC
% C > 1 if there are multiple faces attached to the entity

Num_F = size(F_IND,1);
nnt = length(obj.Nodal_Top);

% get face nodes
for i1 = 1:nnt
    for i2 = 1:length(obj.Nodal_Top(i1).F)
        if ~isempty(obj.Nodal_Top(i1).F{i2})
            for fi = 1:Num_F
                Next_F = obj.Nodal_Top(i1).F{i2}(F_IND(fi,:),:);
                NODES{fi} = [NODES{fi}, Next_F(:)']; % must be a row vector
            end
        end
    end
end

end