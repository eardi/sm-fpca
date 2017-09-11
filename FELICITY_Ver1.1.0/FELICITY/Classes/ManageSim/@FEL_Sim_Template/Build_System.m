function [MAT, RHS] = Build_System(obj,my_matrices,MISC)
%Build_System
%
%   Build the system matrix to be solved (i.e. Ax = b).

% Copyright (c) 05-05-2014,  Shawn W. Walker

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

end