function obj = Define_Finite_Element_Space(obj,MISC)
%Define_Finite_Element_Space
%
%   Define the finite element spaces for the simulation.

% Copyright (c) 01-27-2017,  Shawn W. Walker

obj.Space = []; % fill this in!
% note: obj.Space is a struct whose fields are objects of the FELICITY Class:
%       FiniteElementSpace.

% EXAMPLE: (change this!)

% define DoFmaps (change this!)
Omega_P1_DoFmap = uint32(obj.Mesh.ConnectivityList);

% define FE spaces
P1_RefElem = ReferenceFiniteElement(lagrange_deg1_dim2(),1);
obj.Space.V = FiniteElementSpace('V', P1_RefElem, obj.Mesh, 'Omega');
obj.Space.V = obj.Space.V.Set_DoFmap(obj.Mesh,Omega_P1_DoFmap);
% get fixed and free DoFs
obj.Space.Fixed_DoFs = obj.Space.V.Get_Fixed_DoFs(obj.Mesh,'all');
obj.Space.Free_DoFs = obj.Space.V.Get_Free_DoFs(obj.Mesh,'all');

% store the coordinates of the DoFs
obj.Space.DoF_Coord = FILL_IN;

end