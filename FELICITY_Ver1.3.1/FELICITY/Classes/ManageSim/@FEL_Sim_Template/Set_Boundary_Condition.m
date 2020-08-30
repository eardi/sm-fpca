function obj = Set_Boundary_Condition(obj)
%Set_Boundary_Condition
%
%   Set boundary conditions on the solution variables.

% Copyright (c) 01-27-2017,  Shawn W. Walker

%%%%% EXAMPLE: this must be modified to fit your needs! %%%%%

obj.Solution; % this should be filled in already (see "Initialize_Solution.m")

% get the DoF indices that are *fixed*
Fixed_DoFs = []; % change this!

% evaluate boundary condition functions
XXX = []; % this needs to be defined properly!
BC_Values = Evaluate_BC_Func(XXX); % modify!

% make solution (at fixed DoFs) satisfy the boundary conditions
obj.Solution.v(Fixed_DoFs,:) = BC_Values(Fixed_DoFs,:);

end