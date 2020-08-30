function [MAT, RHS] = Build_System(obj,my_matrices,MISC)
%Build_System
%
%   Build the system matrix to be solved (i.e. Ax = b).

% Copyright (c) 01-27-2017,  Shawn W. Walker

% get sub-matrices...
A = my_matrices.Get_Matrix('A');
B = my_matrices.Get_Matrix('B');
% ...

% get number of DoFs in space...
NP = obj.Space.Q.num_dof;
Z  = sparse(NP,NP);
% ...

% EXAMPLE: define system (change this!)
MAT = [A, B';
       B, Z];
%

% create RHS Data
RHS = []; % fill this in!

% don't forget to include boundary conditions in either MAT and/or RHS!!!

end