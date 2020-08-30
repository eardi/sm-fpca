function obj = Append_Subdomain(obj,Dim_str,Name,SubData)
%Append_Subdomain
%
%   This sets up a data structure for representing a sub-domain in an interval
%   mesh.
%
%   obj = obj.Append_Subdomain(Dim_str,Name,SubData)
%
%   Dim_str = (string) '0D' or '1D' --> topological dimension of the sub-domain.
%   Name    = (string) name of the subdomain.
%   SubData = matrix representing subdomain mesh connectivity that indexes into
%             obj.Points.  See 'private.Get_Subdomain_0D' or
%             'private.Get_Subdomain_1D' for more info.

% Copyright (c) 06-27-2012,  Shawn W. Walker

if strcmp(Dim_str,'0D')
    Data = obj.Get_Subdomain_0D(SubData);
    Dim = 0;
elseif strcmp(Dim_str,'1D')
    Data = obj.Get_Subdomain_1D(SubData);
    Dim = 1;
else
    error('Subdomain dimension is not valid!  Must be ''0D'' or ''1D'' for MeshInterval.');
end

obj = obj.Create_Subdomain(Name,Dim,Data);

end