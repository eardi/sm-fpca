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
%   DoFs = is an (increasing) ordered array of unique DoF indices that are
%          considered *fixed*.
%          Note: this is only for the 1st component of a tensor-valued space.
%
%   DoFs = obj.Get_Fixed_DoFs(Mesh,Comp);
%
%   DoFs = similar to above, except DoFs corresponds to a specific tensor
%          component specified by 'Comp'.
%
%   DoFs = obj.Get_Fixed_DoFs(Mesh,'all');
%
%   DoFs = similar to above, except DoFs includes all fixed DoFs for *all*
%          components of a tensor-valued space.

% Copyright (c) 08-04-2014,  Shawn W. Walker

if (nargin==2)
    ARG = 1; % default to component #1
end
if isempty(ARG)
    ARG = 1; % default to component #1
end
Check_ARG(ARG);

DoFs = [];
if strcmpi(ARG,'all')
    % get fixed DoFs for all components
    for ci = 1:obj.RefElem.Num_Comp
        DoFs_Comp = get_fixed_dofs_for_component(obj,Mesh,ci);
        DoFs = [DoFs; DoFs_Comp];
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

if (Comp > obj.RefElem.Num_Comp)
    error('Component index is too large!');
end

Fixed_DoFs = [];
Num_Fixed = length(obj.Fixed(Comp).Domain);
for ii = 1:Num_Fixed
    Fixed_Name = obj.Fixed(Comp).Domain{ii};
    Fixed_DoFs = [Fixed_DoFs; obj.Get_DoFs_On_Subdomain(Mesh,Fixed_Name)];
end

DoFs_scalar = unique(Fixed_DoFs);
DoFs = obj.Get_DoFs_For_Component(DoFs_scalar,Comp);

end