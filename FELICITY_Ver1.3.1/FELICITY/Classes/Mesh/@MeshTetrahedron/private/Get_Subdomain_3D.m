function Data = Get_Subdomain_3D(obj,Oriented_Tets,STRICT)
%Get_Subdomain_3D
%
%   This sets up a data structure for representing a sub-domain in a tetra
%   mesh.  Dimension of the subdomain is 3-D (i.e. just tet indices).
%
%   Data = obj.Get_Subdomain_3D(Oriented_Tets,STRICT);
%
%   Oriented_Tets = Mx4 matrix of oriented tetra data (indexes into obj.Points).
%   STRICT = (boolean) true means to only accept the Subdomain if *ALL*
%            Oriented_Tets are found (otherwise it outputs an empty matrix).
%            false means to tolerate any unfound tetrahedra, i.e. output the
%            subdomain data for the found tetrahedra only.
%
%   Data = Mx1 vector of tetra indices that refer to tetrahedra in the
%          global mesh that correspond to the Oriented_Tets.
%
%   Data = obj.Get_Subdomain_2D(Tet_Indices);
%
%   Tet_Indices = Mx1 vector of tetra indices that refer to tetrahedra in the
%                 global mesh.
%
%   Data = Tet_Indices.

% Copyright (c) 06-27-2012,  Shawn W. Walker

if (nargin < 3)
    STRICT = false; % default
end

if (size(Oriented_Tets,2)==4) % if we are given actual tets
    % find the global cell index (look at all positive orientations!)
    [TF1, LOC1] = ismember(Oriented_Tets(:,[1 2 3 4]),obj.ConnectivityList,'rows');
    [TF2, LOC2] = ismember(Oriented_Tets(:,[3 1 2 4]),obj.ConnectivityList,'rows');
    [TF3, LOC3] = ismember(Oriented_Tets(:,[2 3 1 4]),obj.ConnectivityList,'rows');
    
    [TF4, LOC4] = ismember(Oriented_Tets(:,[1 4 2 3]),obj.ConnectivityList,'rows');
    [TF5, LOC5] = ismember(Oriented_Tets(:,[2 1 4 3]),obj.ConnectivityList,'rows');
    [TF6, LOC6] = ismember(Oriented_Tets(:,[4 2 1 3]),obj.ConnectivityList,'rows');
    
    [TF7, LOC7] = ismember(Oriented_Tets(:,[1 3 4 2]),obj.ConnectivityList,'rows');
    [TF8, LOC8] = ismember(Oriented_Tets(:,[4 1 3 2]),obj.ConnectivityList,'rows');
    [TF9, LOC9] = ismember(Oriented_Tets(:,[3 4 1 2]),obj.ConnectivityList,'rows');
    
    [TF10, LOC10] = ismember(Oriented_Tets(:,[4 3 2 1]),obj.ConnectivityList,'rows');
    [TF11, LOC11] = ismember(Oriented_Tets(:,[2 4 3 1]),obj.ConnectivityList,'rows');
    [TF12, LOC12] = ismember(Oriented_Tets(:,[3 2 4 1]),obj.ConnectivityList,'rows');
    Data = [LOC1(TF1);    LOC2(TF2);  LOC3(TF3);
            LOC4(TF4);    LOC5(TF5);  LOC6(TF6);
            LOC7(TF7);    LOC8(TF8);  LOC9(TF9);
            LOC10(TF10); LOC11(TF11); LOC12(TF12)];
    if (length(Data)~=size(Oriented_Tets,1))
        if STRICT
            Data = [];
            return;
        else
            % some tets were not found
            % output a message!
            disp(['Subdomain cells were not found in ', obj.Name, ' mesh...']);
            disp('          ... they will be ignored.');
        end
    end
elseif (size(Oriented_Tets,2)==1) % they must just be tetrahedron indices
    Data = Oriented_Tets;
else
    disp('ERROR: The given subdomain must either be an Mx4 matrix of vertex indices, where each row represents an oriented tetrahedron,');
    disp('ERROR:               or it must be an Mx1 vector of tetrahedron indices, where each row indexes a tetrahedron in the mesh!');
    error('Make sure you are passing the correct subdomain data and that the topological dimension is correct!');
end

% simple error checks
if (min(Data) < 1)
    error('The given subdomain must have positive tetrahedra indices!');
end
if (max(Data) > obj.Num_Cell)
    error('The given subdomain has tetrahedra indices that are greater than the number of tetrahedra in the mesh!');
end

end