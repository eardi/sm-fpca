function Data = Get_Subdomain_2D(obj,Oriented_Tri,STRICT)
%Get_Subdomain_2D
%
%   This sets up a data structure for representing a sub-domain in a triangle
%   mesh.  Dimension of the subdomain is 2-D (i.e. just triangle indices).
%
%   Data = obj.Get_Subdomain_2D(Oriented_Tri,STRICT);
%
%   Oriented_Tri = Mx3 matrix of oriented triangle data (indexes into obj.Points).
%   STRICT = (boolean) true means to only accept the Subdomain if *ALL*
%            Oriented_Tri are found (otherwise it outputs an empty matrix).
%            false means to tolerate any unfound triangles, i.e. output the
%            subdomain data for the found triangles only.
%
%   Data = Mx1 vector of triangle indices that refer to triangles in the
%          global mesh that correspond to the Oriented_Tri.
%
%   Data = obj.Get_Subdomain_2D(Tri_Indices);
%
%   Tri_Indices = Mx1 vector of triangles indices that refer to triangles in the
%                 global mesh.
%
%   Data = Tri_Indices.

% Copyright (c) 06-27-2012,  Shawn W. Walker

if (nargin < 3)
    STRICT = false; % default
end

if (size(Oriented_Tri,2)==3) % if we are given actual triangles
    % find the global cell index (look at all positive orientations!)
    [TF1, LOC1] = ismember(Oriented_Tri(:,[1 2 3]),obj.ConnectivityList,'rows');
    [TF2, LOC2] = ismember(Oriented_Tri(:,[3 1 2]),obj.ConnectivityList,'rows');
    [TF3, LOC3] = ismember(Oriented_Tri(:,[2 3 1]),obj.ConnectivityList,'rows');
    Data = [LOC1(TF1); LOC2(TF2); LOC3(TF3)];
    if (length(Data)~=size(Oriented_Tri,1))
        if STRICT
            Data = [];
            return;
        else
            % some triangles were not found
            % output a message!
            disp(['Subdomain cells were not found in ', obj.Name, ' mesh...']);
            disp('          ... they will be ignored.');
        end
    end
elseif (size(Oriented_Tri,2)==1) % they must just be triangle indices
    Data = Oriented_Tri;
else
    disp('ERROR: The given subdomain must either be an Mx3 matrix of vertex indices, where each row represents an oriented triangle,');
    disp('ERROR:               or it must be an Mx1 vector of triangle indices, where each row indexes a triangle in the mesh!');
    error('Make sure you are passing the correct subdomain data and that the topological dimension is correct!');
end

% simple error checks
if (min(Data) < 1)
    error('The given subdomain must have positive triangle indices!');
end
if (max(Data) > obj.Num_Cell)
    error('The given subdomain has triangle indices that are greater than the number of triangles in the mesh!');
end

end