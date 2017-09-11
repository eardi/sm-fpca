function Local_Transformation = Get_Basis_Function_Local_Transformation(obj)
%Get_Basis_Function_Local_Transformation
%
%   This gets the needed local transformation info.

% Copyright (c) 06-27-2012,  Shawn W. Walker

Subdomain_Top_Dim  = obj.Domain.Subdomain.Top_Dim;
DoI_Top_Dim        = obj.Domain.Integration_Domain.Top_Dim;

if (Subdomain_Top_Dim==1)
    if (DoI_Top_Dim==1) % codim = 0
        Local_Transformation = obj.Local_Basis_Function_Transformation_Simple();
    else
        error('Invalid!');
    end
elseif (Subdomain_Top_Dim==2)
    if (DoI_Top_Dim==1) % codim = 1
        Local_Transformation = obj.Local_Basis_Function_Transformation_Edges_In_Triangle();
    elseif (DoI_Top_Dim==2) % codim = 0
        Local_Transformation = obj.Local_Basis_Function_Transformation_Simple();
    else
        error('Invalid!');
    end
elseif (Subdomain_Top_Dim==3)
    if (DoI_Top_Dim==1) % codim = 2
        Local_Transformation = obj.Local_Basis_Function_Transformation_Edges_In_Tetrahedron();
    elseif (DoI_Top_Dim==2) % codim = 1
        Local_Transformation = obj.Local_Basis_Function_Transformation_Triangles_In_Tetrahedron();
    elseif (DoI_Top_Dim==3) % codim = 0
        Local_Transformation = obj.Local_Basis_Function_Transformation_Simple();
    else
        error('Invalid!');
    end
else
    error('Invalid!');
end

end