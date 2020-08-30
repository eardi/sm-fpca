function Dim = Get_Intrinsic_Dim_Of_Simplex(Simplex_Type)
%Get_Intrinsic_Dim_Of_Simplex
%
%   This returns the dimension of the chosen domain: ``Hold_All'' or
%   ``Subdomain'' (i.e. the intrinsic dimension).

% Copyright (c) 03-19-2012,  Shawn W. Walker

if strcmp(Simplex_Type,'interval')
    Dim = 1;
elseif strcmp(Simplex_Type,'triangle')
    Dim = 2;
elseif strcmp(Simplex_Type,'tetrahedron')
    Dim = 3;
else
    error('Invalid!');
end

end