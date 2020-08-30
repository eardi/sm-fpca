function Local_Map = Generate_Local_Maps_For_Geometric_Basis_Functions(obj,entity_ind)
%Generate_Local_Maps_For_Geometric_Basis_Functions
%
%   This generates two symbolic maps (expressions) for generating geometric
%   basis functions that are reduced to Subdomains and Domains of Integration
%   (DoI's).
%
%   Local_Map = obj.Generate_Local_Maps_For_Geometric_Basis_Functions(ent);
%
%   ent = local mesh topological entity index; either a 1 or 2 length vector of
%         local indices; 2 length case is a special case.
%
%   Local_Map = struct containing the two maps:
%              .Sub = FELSymFunc object that defines a map from the reference
%                     element of the Subdomain to a given topological entity in
%                     the Global cell (same topological dimension as the
%                     Subdomain, but the geometric dimension may be higher).
%              .DoI = FELSymFunc object; similar, except it maps from the
%                     reference element of the DoI to a topological entity in
%                     the Subdomain cell.
%
%   The map Local_Map.Sub has range in the Global cell reference element, and
%   domain is the Subdomain cell reference element.
%
%   The map Local_Map.DoI has range in the Subdomain cell reference element, and
%   domain is the DoI cell reference element.
%
%   Thus, the two maps can be composed to create a new map that goes from the
%   DoI to the Global cell reference element.
%
%     Sub  Top_Dim  |     independent variable
%         1         |             u_hat
%         2         |          u_hat,v_hat
%         3         |       u_hat,v_hat,w_hat
%
%     DoI  Top_Dim  |     independent variable
%         1         |             x_hat
%         2         |          x_hat,y_hat
%         3         |       x_hat,y_hat,z_hat

% Copyright (c) 05-20-2016,  Shawn W. Walker

Global_Hold_All_Top_Dim = obj.Domain.Global.Top_Dim;
Subdomain_Top_Dim       = obj.Domain.Subdomain.Top_Dim;
DoI_Top_Dim             = obj.Domain.Integration_Domain.Top_Dim;

% Note: 3 >= Global_Hold_All_Top_Dim >= Subdomain_Top_Dim >= DoI_Top_Dim >= 1

% define symbolic variables
u = sym('u_hat');
v = sym('v_hat');
w = sym('w_hat');
x = sym('x_hat');
y = sym('y_hat');
z = sym('z_hat');

if (Global_Hold_All_Top_Dim==1)
    % only get the identity
    if (Subdomain_Top_Dim==1)
        Sub_Sym_Map = u; % identity map
        if (DoI_Top_Dim==1) % codim = 0
            DoI_Sym_Map = x; % identity map
        else
            error('Invalid!');
        end
    else
        error('Invalid!');
    end
elseif (Global_Hold_All_Top_Dim==2)
    if (Subdomain_Top_Dim==2) % codim = 0
        Sub_Sym_Map = [u;v]; % identity map
        if (DoI_Top_Dim==2)
            DoI_Sym_Map = [x;y]; % identity map
        elseif (DoI_Top_Dim==1) % codim = 1
            DoI_Sym_Map = map_unit_interval_to_tri_edge(x,entity_ind(1));
        else
            error('Invalid!');
        end
    elseif (Subdomain_Top_Dim==1)
        Sub_Sym_Map = map_unit_interval_to_tri_edge(u,entity_ind(1));
        if (DoI_Top_Dim==1) % codim = 1
            DoI_Sym_Map = x; % identity map
        else
            error('Invalid!');
        end
    else
        error('Invalid!');
    end
elseif (Global_Hold_All_Top_Dim==3)
    if (Subdomain_Top_Dim==3)
        Sub_Sym_Map = [u;v;w]; % identity map
        if (DoI_Top_Dim==3) % codim = 0
            DoI_Sym_Map = [x;y;z]; % identity map
        elseif (DoI_Top_Dim==2) % codim = 1
            DoI_Sym_Map = map_unit_triangle_to_tet_face([x;y],entity_ind(1));
        elseif (DoI_Top_Dim==1) % codim = 2
            DoI_Sym_Map = map_unit_interval_to_tet_edge(x,entity_ind(1));
        else
            error('Invalid!');
        end
        
    elseif (Subdomain_Top_Dim==2)
        Sub_Sym_Map = map_unit_triangle_to_tet_face([u;v],entity_ind(1));
        if (DoI_Top_Dim==2) % codim = 1
            DoI_Sym_Map = [x;y]; % identity map
        elseif (DoI_Top_Dim==1) % codim = 2
            % if this is the special case, then we want the second entity index
            DoI_Sym_Map = map_unit_interval_to_tri_edge(x,entity_ind(end));
        else
            error('Invalid!');
        end
    elseif (Subdomain_Top_Dim==1)
        Sub_Sym_Map = map_unit_interval_to_tet_edge(u,entity_ind(1));
        if (DoI_Top_Dim==1) % codim = 2
            DoI_Sym_Map = x; % identity map
        else
            error('Invalid!');
        end
    else
        error('Invalid!');
    end
else
    error('Invalid!');
end

if (Subdomain_Top_Dim==1)
    Sub_Vars = {'u_hat'};
elseif (Subdomain_Top_Dim==2)
    Sub_Vars = {'u_hat', 'v_hat'};
elseif (Subdomain_Top_Dim==3)
    Sub_Vars = {'u_hat', 'v_hat', 'w_hat'};
else
    error('Invalid!');
end
Local_Map.Sub = FELSymFunc(Sub_Sym_Map,Sub_Vars);

if (DoI_Top_Dim==1)
    DoI_Vars = {'x_hat'};
elseif (DoI_Top_Dim==2)
    DoI_Vars = {'x_hat', 'y_hat'};
elseif (DoI_Top_Dim==3)
    DoI_Vars = {'x_hat', 'y_hat', 'z_hat'};
else
    error('Invalid!');
end
Local_Map.DoI = FELSymFunc(DoI_Sym_Map,DoI_Vars);

end

function Sym_Map = map_unit_interval_to_tri_edge(indep_var,Entity_Index)

% vertices of the reference triangle
A1 = [0; 0];
A2 = [1; 0];
A3 = [0; 1];

% map quad rule from interval to 1 of 3 edges with orientation
if (Entity_Index==1) % edge1, pos
    p1 = A2;
    p2 = A3;
elseif (Entity_Index==2) % edge2, pos
    p1 = A3;
    p2 = A1;
elseif (Entity_Index==3) % edge3, pos
    p1 = A1;
    p2 = A2;
elseif (Entity_Index==-1) % edge1, neg
    p1 = A3;
    p2 = A2;
elseif (Entity_Index==-2) % edge2, neg
    p1 = A1;
    p2 = A3;
elseif (Entity_Index==-3) % edge3, neg
    p1 = A2;
    p2 = A1;
else
    error('Entity_Index outside valid range!');
end

% Map = (1 - t) * p1 + t*p2
Sym_Map = (1 - indep_var) * p1 + indep_var * p2;

end

function Sym_Map = map_unit_interval_to_tet_edge(indep_var,Entity_Index)

% vertices of the reference tetrahedron
A1 = [0; 0; 0];
A2 = [1; 0; 0];
A3 = [0; 1; 0];
A4 = [0; 0; 1];

% map quad rule from interval to 1 of 6 edges with orientation
if (Entity_Index==1) % edge1, pos
    p1 = A1;
    p2 = A2;
elseif (Entity_Index==2) % edge2, pos
    p1 = A1;
    p2 = A3;
elseif (Entity_Index==3) % edge3, pos
    p1 = A1;
    p2 = A4;
elseif (Entity_Index==4) % edge4, pos
    p1 = A2;
    p2 = A3;
elseif (Entity_Index==5) % edge5, pos
    p1 = A3;
    p2 = A4;
elseif (Entity_Index==6) % edge6, pos
    p1 = A4;
    p2 = A2;
elseif (Entity_Index==-1) % edge1, neg
    p1 = A2;
    p2 = A1;
elseif (Entity_Index==-2) % edge2, neg
    p1 = A3;
    p2 = A1;
elseif (Entity_Index==-3) % edge3, neg
    p1 = A4;
    p2 = A1;
elseif (Entity_Index==-4) % edge4, neg
    p1 = A3;
    p2 = A2;
elseif (Entity_Index==-5) % edge5, neg
    p1 = A4;
    p2 = A3;
elseif (Entity_Index==-6) % edge6, neg
    p1 = A2;
    p2 = A4;
else
    error('Entity_Index outside valid range!');
end

% Map = (1 - t) * p1 + t*p2
Sym_Map = (1 - indep_var) * p1 + indep_var * p2;

end

function Sym_Map = map_unit_triangle_to_tet_face(indep_var,Entity_Index)

% vertices of the reference tetrahedron
A1 = [0; 0; 0];
A2 = [1; 0; 0];
A3 = [0; 1; 0];
A4 = [0; 0; 1];

% map quad rule from ref triangle to 1 of 4 faces with orientation
if (Entity_Index==1) % face1, pos
    v1 = A2;
    v2 = A3;
    v3 = A4;
elseif (Entity_Index==2) % face2, pos
    v1 = A1;
    v2 = A4;
    v3 = A3;
elseif (Entity_Index==3) % face3, pos
    v1 = A1;
    v2 = A2;
    v3 = A4;
elseif (Entity_Index==4) % face4, pos
    v1 = A1;
    v2 = A3;
    v3 = A2;
elseif (Entity_Index==-1) % face1, neg
    v1 = A2; % pivot
    v2 = A4;
    v3 = A3;
elseif (Entity_Index==-2) % face2, neg
    v1 = A1; % pivot
    v2 = A3;
    v3 = A4;
elseif (Entity_Index==-3) % face3, neg
    v1 = A1; % pivot
    v2 = A4;
    v3 = A2;
elseif (Entity_Index==-4) % face4, neg
    v1 = A1; % pivot
    v2 = A2;
    v3 = A3;
else
    error('Entity_Index outside valid range!');
end

% Map = (1 - r - s) * v1 + r*v2 + s*v3
Sym_Map = (1 - indep_var(1) - indep_var(2)) * v1 +...
                      indep_var(1) * v2 +...
                      indep_var(2) * v3;
%
end

% function Sym_Map = map_unit_interval_to_tet_face_edge(indep_var,Entity_Index)
% 
% Sub_Entity_Index = Entity_Index(1);
% DoI_Entity_Index = Entity_Index(2);
% 
% % vertices of the reference tetrahedron
% A1 = [0; 0; 0];
% A2 = [1; 0; 0];
% A3 = [0; 1; 0];
% A4 = [0; 0; 1];
% 
% % first get the local face with orientation
% if (Sub_Entity_Index==1) % face1, pos
%     v1 = A2;
%     v2 = A3;
%     v3 = A4;
% elseif (Sub_Entity_Index==2) % face2, pos
%     v1 = A1;
%     v2 = A4;
%     v3 = A3;
% elseif (Sub_Entity_Index==3) % face3, pos
%     v1 = A1;
%     v2 = A2;
%     v3 = A4;
% elseif (Sub_Entity_Index==4) % face4, pos
%     v1 = A1;
%     v2 = A3;
%     v3 = A2;
% elseif (Sub_Entity_Index==-1) % face1, neg
%     v1 = A2; % pivot
%     v2 = A4;
%     v3 = A3;
% elseif (Sub_Entity_Index==-2) % face2, neg
%     v1 = A1; % pivot
%     v2 = A3;
%     v3 = A4;
% elseif (Sub_Entity_Index==-3) % face3, neg
%     v1 = A1; % pivot
%     v2 = A4;
%     v3 = A2;
% elseif (Sub_Entity_Index==-4) % face4, neg
%     v1 = A1; % pivot
%     v2 = A2;
%     v3 = A3;
% else
%     error('Sub_Entity_Index outside valid range!');
% end
% 
% % Now, get the local edge (of the local face) with orientation
% if (DoI_Entity_Index==1) % edge1, pos
%     p1 = v2;
%     p2 = v3;
% elseif (DoI_Entity_Index==2) % edge2, pos
%     p1 = v3;
%     p2 = v1;
% elseif (DoI_Entity_Index==3) % edge3, pos
%     p1 = v1;
%     p2 = v2;
% elseif (DoI_Entity_Index==-1) % edge1, neg
%     p1 = v3;
%     p2 = v2;
% elseif (DoI_Entity_Index==-2) % edge2, neg
%     p1 = v1;
%     p2 = v3;
% elseif (DoI_Entity_Index==-3) % edge3, neg
%     p1 = v2;
%     p2 = v1;
% else
%     error('DoI_Entity_Index outside valid range!');
% end
% 
% % Map = (1 - t) * p1 + t*p2
% Sym_Map = (1 - indep_var) * p1 + indep_var * p2;
% 
% end