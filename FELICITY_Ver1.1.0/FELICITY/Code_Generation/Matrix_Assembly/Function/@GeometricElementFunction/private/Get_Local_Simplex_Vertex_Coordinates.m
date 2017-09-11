function Points = Get_Local_Simplex_Vertex_Coordinates(Compute_Map)
%Get_Local_Simplex_Vertex_Coordinates
%
%   This returns the coordinates of the vertices of a topological entity that is
%   embedded in a higher dimensional simplex.

% Copyright (c) 04-28-2012,  Shawn W. Walker

if strcmp(Compute_Map.Integration_Simplex_Type,'interval')
    if (Compute_Map.Codim==0)
        Points = [0;
                  1];
    elseif (Compute_Map.Codim==1) % embedded in a triangle
        X1 = [0, 0];
        X2 = [1, 0];
        X3 = [0, 1];
        if (Compute_Map.Entity_Index==1)
            Points = [X2; X3];
        elseif (Compute_Map.Entity_Index==2)
            Points = [X3; X1];
        elseif (Compute_Map.Entity_Index==3)
            Points = [X1; X2];
        elseif (Compute_Map.Entity_Index==-1)
            Points = [X3; X2];
        elseif (Compute_Map.Entity_Index==-2)
            Points = [X1; X3];
        elseif (Compute_Map.Entity_Index==-3)
            Points = [X2; X1];
        else
            error('Invalid!');
        end
    elseif (Compute_Map.Codim==2) % embedded in a tetrahedron
        X1 = [0, 0, 0];
        X2 = [1, 0, 0];
        X3 = [0, 1, 0];
        X4 = [0, 0, 1];
        if (Compute_Map.Entity_Index==1)
            Points = [X1; X2];
        elseif (Compute_Map.Entity_Index==2)
            Points = [X1; X3];
        elseif (Compute_Map.Entity_Index==3)
            Points = [X1; X4];
        elseif (Compute_Map.Entity_Index==4)
            Points = [X2; X3];
        elseif (Compute_Map.Entity_Index==5)
            Points = [X3; X4];
        elseif (Compute_Map.Entity_Index==6)
            Points = [X4; X2];
        elseif (Compute_Map.Entity_Index==-1)
            Points = [X2; X1];
        elseif (Compute_Map.Entity_Index==-2)
            Points = [X3; X1];
        elseif (Compute_Map.Entity_Index==-3)
            Points = [X4; X1];
        elseif (Compute_Map.Entity_Index==-4)
            Points = [X3; X2];
        elseif (Compute_Map.Entity_Index==-5)
            Points = [X4; X3];
        elseif (Compute_Map.Entity_Index==-6)
            Points = [X2; X4];
        else
            error('Invalid!');
        end
    else
        error('Invalid!');
    end
    
elseif strcmp(Compute_Map.Integration_Simplex_Type,'triangle')
    if (Compute_Map.Codim==0)
        Points = [0, 0;
                  1, 0;
                  0, 1];
    elseif (Compute_Map.Codim==1) % embedded in a tetrahedron
        X1 = [0, 0, 0];
        X2 = [1, 0, 0];
        X3 = [0, 1, 0];
        X4 = [0, 0, 1];
        if (Compute_Map.Entity_Index==1)
            Points = [X2; X3; X4];
        elseif (Compute_Map.Entity_Index==2)
            Points = [X1; X4; X3];
        elseif (Compute_Map.Entity_Index==3)
            Points = [X1; X2; X4];
        elseif (Compute_Map.Entity_Index==4)
            Points = [X1; X3; X2];
        elseif (Compute_Map.Entity_Index==-1)
            Points = [X2; X4; X3];
        elseif (Compute_Map.Entity_Index==-2)
            Points = [X1; X3; X4];
        elseif (Compute_Map.Entity_Index==-3)
            Points = [X1; X4; X2];
        elseif (Compute_Map.Entity_Index==-4)
            Points = [X1; X2; X3];
        else
            error('Invalid!');
        end
    else
        error('Invalid!');
    end
    
elseif strcmp(Compute_Map.Integration_Simplex_Type,'tetrahedron')
    if (Compute_Map.Codim==0)
        Points = [0, 0, 0;
                  1, 0, 0;
                  0, 1, 0;
                  0, 0, 1];
    else
        error('Invalid!');
    end
else
    error('Invalid!');
end

end