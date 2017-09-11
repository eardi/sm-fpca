function DoFs = Get_Free_DoFs(obj,Mesh,ARG)
%Get_Free_DoFs
%
%   Similar to 'Get_Fixed_DoFs', except this returns the DoFs that are *free*
%   (i.e. not fixed by some Dirichlet condition).
%
%   DoFs = obj.Get_Free_DoFs(Mesh);
%
%   Mesh = (FELICITY mesh) this is the mesh that the FE space is defined on.
%
%   DoFs = is an (increasing) ordered array of unique DoF indices that are
%          considered *free*.
%          Note: this is only for the 1st component of a tensor-valued space.
%
%   DoFs = obj.Get_Free_DoFs(Mesh,Comp);
%
%   DoFs = similar to above, except DoFs corresponds to a specific tensor
%          component specified by 'Comp'.
%
%   DoFs = obj.Get_Free_DoFs(Mesh,'all');
%
%   DoFs = similar to above, except DoFs includes all free DoFs for *all*
%          components of a tensor-valued space.

% Copyright (c) 08-04-2014,  Shawn W. Walker

if (nargin==2)
    ARG = 1; % default to component #1
end
if isempty(ARG)
    ARG = 1; % default to component #1
end
Check_ARG(ARG);

% first get the fixed DoFs
Fixed_DoFs = obj.Get_Fixed_DoFs(Mesh,ARG);
% ALL DoFs
All_DoFs = obj.Get_DoFs(ARG);

% then setminus
DoFs = setdiff(All_DoFs(:),Fixed_DoFs);

end