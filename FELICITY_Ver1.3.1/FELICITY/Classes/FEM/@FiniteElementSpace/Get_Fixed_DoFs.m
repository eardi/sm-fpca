function DoFs = Get_Fixed_DoFs(obj,Mesh,ARG)
%Get_Fixed_DoFs
%
%   Similar to 'Get_DoFs', except this only returns the DoFs that are fixed
%   (i.e. fixed by some Dirichlet condition).  Note: the functionality is a
%   little different from 'Get_DoFs'.
%
%   DoFs = obj.Get_Fixed_DoFs(Mesh);
%
%   Mesh = (FELICITY mesh) this is the mesh that the FE space is defined on.
%
%   DoFs = is an (increasing) Rx1 ordered array of unique DoF indices that
%          are considered *fixed*.
%          Note: this is only for the 1st component of a tuple-valued space.
%
%   DoFs = obj.Get_Fixed_DoFs(Mesh,Comp);
%
%   DoFs = similar to above, except DoFs corresponds to a specific tuple
%          component specified by 'Comp', which is a row vector of length
%          1 or 2 depending on the tuple-size of the FE space.
%          Note: DoFs are shifted by the corresponding linear index version
%          of 'Comp'.
%
%   DoFs = obj.Get_Fixed_DoFs(Mesh,'all');
%
%   DoFs = similar to above, except DoFs includes all free DoFs for *all*
%          components of a tuple-valued space.

% Copyright (c) 03-26-2018,  Shawn W. Walker

if (nargin==2)
    ARG = [1, 1]; % default to component (1,1)
end
if isempty(ARG)
    ARG = [1, 1]; % default to component (1,1)
end
Check_ARG(ARG);

if strcmpi(ARG,'all')
    % get fixed DoFs for all components
    DoFs = [];
    for ci_1 = 1:obj.Num_Comp(1)
        for ci_2 = 1:obj.Num_Comp(2)
            DoFs_Comp = get_fixed_dofs_for_component(obj,Mesh,[ci_1, ci_2]);
            DoFs = [DoFs; DoFs_Comp];
        end
    end
else
    % get fixed DoFs for a specific component
    Comp = ARG;
    DoFs = get_fixed_dofs_for_component(obj,Mesh,Comp);
end

% error check
DoF_TEMP = unique(DoFs(:));
if (length(DoF_TEMP)~=length(DoFs))
    error('This should not happen!  Please report this bug!');
end

end

function DoFs = get_fixed_dofs_for_component(obj,Mesh,Comp)

Comp = obj.Process_Tuple_Component(Comp);

Fixed_DoFs = [];
Num_Fixed = length(obj.Fixed(Comp(1),Comp(2)).Domain);
for ii = 1:Num_Fixed
    Fixed_Name = obj.Fixed(Comp(1),Comp(2)).Domain{ii};
    Fixed_DoFs = [Fixed_DoFs; obj.Get_DoFs_On_Subdomain(Mesh,Fixed_Name)];
end

DoFs_scalar = unique(Fixed_DoFs);
DoFs = obj.Get_DoFs_For_Component(DoFs_scalar,Comp);

end