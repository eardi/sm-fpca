function obj = Create_Subdomain(obj,Name,Dim,Data)
%Create_Subdomain
%
%   This setups a data structure for representing a generic sub-domain in a
%   mesh.
%
%   obj  = obj.Create_Subdomain(Name,Dim,Data);
%
%   Name = (string) name of the subdomain.
%   Dim  = 0, 1, 2, or 3; topological dimension of the sub-domain.
%   Data = Rx1 or Rx2 matrix, where R is the number of elements in the
%          subdomain.  Elements in a subdomain are defined with respect to the
%          enclosing cell index and *local* topological entities.  First column
%          specifies the cell indices in the global mesh that contain the
%          subdomain.  Second column specifies the local topological entity
%          indices for each subdomain element (e.g. local edge indices for a 1-D
%          subdomain contained in a 2-D triangle mesh).

% Copyright (c) 02-14-2013,  Shawn W. Walker

if ~ischar(Name)
    error('Name should be a string!');
end
if or(Dim < 0,Dim > 3)
    error('Dim (dimension) is invalid!');
end

SUB = Get_Subdomain_Struct();

SUB.Name = Name;
SUB.Dim  = Dim;
% you should always have the data sorted!  do not change this!
% this must be sorted for refinement, I think.
SUB.Data = sortrows(int32(Data),1);

% can have various consistency checks later...

obj.Check_For_Duplicate_Names(SUB.Name);

% get num current subdomains
Num_Sub = length(obj.Subdomain);
if (Num_Sub==0)
    obj.Subdomain = SUB;
else
    obj.Subdomain(Num_Sub+1) = SUB;
end

end