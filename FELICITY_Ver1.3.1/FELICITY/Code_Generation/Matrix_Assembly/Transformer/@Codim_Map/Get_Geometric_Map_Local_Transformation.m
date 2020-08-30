function Local_Map = Get_Geometric_Map_Local_Transformation(obj)
%Get_Geometric_Map_Local_Transformation
%
%   This gets the needed local transformation info.
%   Note: these maps work for both the ``intrinsic'' and ``restriction'' cases.

% Copyright (c) 06-06-2012,  Shawn W. Walker

Global_Hold_All_Top_Dim = obj.Domain.Global.Top_Dim;
Subdomain_Top_Dim       = obj.Domain.Subdomain.Top_Dim;
DoI_Top_Dim             = obj.Domain.Integration_Domain.Top_Dim;

if (Global_Hold_All_Top_Dim==1)
    if (Subdomain_Top_Dim==1)
        if (DoI_Top_Dim==1) % codim = 0
            Local_Map = obj.Local_Geometric_Map_Simple(); % intrinsic
        else
            error('Invalid!');
        end
    else
        error('Invalid!');
    end
elseif (Global_Hold_All_Top_Dim==2)
    if (Subdomain_Top_Dim==2) % codim = 0
        if (DoI_Top_Dim==2)
            Local_Map = obj.Local_Geometric_Map_Simple(); % intrinsic/restriction?
        elseif (DoI_Top_Dim==1) % codim = 1
            Local_Map = obj.Local_Geometric_Map_Edges_In_Triangle(); % restriction
        else
            error('Invalid!');
        end
    elseif (Subdomain_Top_Dim==1)
        if (DoI_Top_Dim==1) % codim = 1
            Local_Map = obj.Local_Geometric_Map_Edges_In_Triangle(); % intrinsic
        else
            error('Invalid!');
        end
    else
        error('Invalid!');
    end
elseif (Global_Hold_All_Top_Dim==3)
    if (Subdomain_Top_Dim==3)
        if (DoI_Top_Dim==3) % codim = 0
            Local_Map = obj.Local_Geometric_Map_Simple(); % intrinsic/restriction?
        elseif (DoI_Top_Dim==2) % codim = 1
            Local_Map = obj.Local_Geometric_Map_Triangles_In_Tetrahedron(); % restriction
        elseif (DoI_Top_Dim==1) % codim = 2
            Local_Map = obj.Local_Geometric_Map_Edges_In_Tetrahedron(); % restriction
        else
            error('Invalid!');
        end
    elseif (Subdomain_Top_Dim==2)
        if (DoI_Top_Dim==2) % codim = 1
            Local_Map = obj.Local_Geometric_Map_Triangles_In_Tetrahedron(); % intrinsic?
        elseif (DoI_Top_Dim==1) % codim = 2
            Local_Map = obj.Local_Geometric_Map_Edges_In_Triangles_In_Tetrahedron(); % intrinsic?
        else
            error('Invalid!');
        end
    elseif (Subdomain_Top_Dim==1)
        if (DoI_Top_Dim==1) % codim = 2
            Local_Map = obj.Local_Geometric_Map_Edges_In_Tetrahedron(); % intrinsic
        else
            error('Invalid!');
        end
    else
        error('Invalid!');
    end
else
    error('Invalid!');
end

end