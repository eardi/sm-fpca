function Num_DoF_on_Face = Get_Num_DoFs_On_Face(Elem,F_Set)
%Get_Num_DoFs_On_Face
%
%   This returns the number of DoFs in a particular set of Face DoFs.  This
%   accounts for 2D-Faces or 3-D Faces.

% Copyright (c) 04-07-2010,  Shawn W. Walker

error('DO not use!!!!');

if and(Elem.Dim==3,strcmp(Elem.Domain,'tetrahedron'))
    if ~isempty(F_Set)
        Num_DoF_on_Face = 3*length(F_Set{1,1});
    else
        Num_DoF_on_Face = 0;
    end
else
    Num_DoF_on_Face  = size(F_Set,2);
end

end