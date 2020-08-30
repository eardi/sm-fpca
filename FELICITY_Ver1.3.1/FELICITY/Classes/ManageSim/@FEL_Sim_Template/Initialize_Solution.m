function obj = Initialize_Solution(obj,MISC)
%Initialize_Solution
%
%   Initialize solution variable (finite element coef. arrays) for the simulation.

% Copyright (c) 05-05-2014,  Shawn W. Walker

obj.Solution = []; % fill this in!
% note: obj.Solution is a struct whose fields are coefficient arrays (i.e. matrices) that
%       represent finite element (FE) functions.  These finite element functions have a
%       corresponding finite element space contained in obj.Space.

% EXAMPLE: (change this!)
obj.Solution.v = obj.Space.V.Get_Zero_Function();
% ...

end