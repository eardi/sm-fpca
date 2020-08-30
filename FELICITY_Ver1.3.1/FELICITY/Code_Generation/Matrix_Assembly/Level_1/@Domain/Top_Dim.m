function TD = Top_Dim(obj)
%Top_Dim
%
%   This returns the topological dimension of the Domain.
%
%   TD = obj.Top_Dim;

% Copyright (c) 08-01-2011,  Shawn W. Walker

if strcmp(obj.Type,'interval')
    TD = 1;
elseif strcmp(obj.Type,'triangle')
    TD = 2;
elseif strcmp(obj.Type,'tetrahedron')
    TD = 3;
else
    error('Type not recognized!');
end

end