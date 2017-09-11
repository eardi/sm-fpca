function FH = Print_DoFs(obj)
%Print_DoFs
%
%   This creates a figure that describes the topological layout of the
%   Degrees-of-Freedom (DoFs) on the reference element.
%
%   FH = obj.Print_DoFs;
%
%   FH = figure handle.

% Copyright (c) 05-01-2012,  Shawn W. Walker

if (obj.Elem.Top_Dim==1)
    FH = obj.Print_DoFs_interval();
elseif (obj.Elem.Top_Dim==2)
    FH = obj.Print_DoFs_triangle();
elseif (obj.Elem.Top_Dim==3)
    FH = obj.Print_DoFs_tetrahedron();
else
    error('Invalid');
end

end