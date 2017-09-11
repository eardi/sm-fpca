function Num = Get_Num_Local_Entities(TopDim,CoDim)
%Get_Num_Local_Entities
%
%   This gets the number of local mesh entities with topological dimension
%   TopDim in a cell with topological dimension (TopDim + CoDim).

% Copyright (c) 06-06-2012,  Shawn W. Walker

if (TopDim==0) 
    if (CoDim==0) % vertices in a vertex
        Num = 1; % this should never be used.
    elseif (CoDim==1) % vertices in an interval
        Num = 2;
    elseif (CoDim==2) % vertices in a  triangle
        Num = 3;
    elseif (CoDim==3) % vertices in a  tetrahedron
        Num = 4;
    else
        error('Not implemented!');
    end
elseif (TopDim==1)
    if (CoDim==0) % edges in an edge
        Num = 1;
    elseif (CoDim==1) % edges in a triangle
        Num = 3;
    elseif (CoDim==2) % edges in a tetrahedron
        Num = 6;
    else
        error('Not implemented!');
    end
elseif (TopDim==2)
    if (CoDim==0) % triangles in a triangle
        Num = 1;
    elseif (CoDim==1) % triangles in a tetrahedron
        Num = 4;
    else
        error('Not implemented!');
    end
elseif (TopDim==3)
    if (CoDim==0) % tets in a tet
        Num = 1;
    else
        error('Not implemented!');
    end
end

end