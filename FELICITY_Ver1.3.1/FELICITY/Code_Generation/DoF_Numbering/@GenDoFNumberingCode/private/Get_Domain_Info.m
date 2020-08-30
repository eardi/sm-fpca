function Domain = Get_Domain_Info(Elem)
%Get_Domain_Info
%
%   Extract info about the local element domain (simplex).

% Copyright (c) 12-01-2010,  Shawn W. Walker

if and(Elem.Dim==1,strcmp(Elem.Domain,'interval'))
    % simplex info
    Domain.Num_Vtx  = 2;
    Domain.Num_Edge = 1;
    Domain.Num_Face = 0;
    Domain.Num_Tet  = 0;
elseif and(Elem.Dim==2,strcmp(Elem.Domain,'triangle'))
    % simplex info
    Domain.Num_Vtx  = 3;
    Domain.Num_Edge = 3;
    Domain.Num_Face = 1;
    Domain.Num_Tet  = 0;
elseif and(Elem.Dim==3,strcmp(Elem.Domain,'tetrahedron'))
    % simplex info
    Domain.Num_Vtx  = 4;
    Domain.Num_Edge = 6;
    Domain.Num_Face = 4;
    Domain.Num_Tet  = 1;
else
    error('Not implemented!');
end

end