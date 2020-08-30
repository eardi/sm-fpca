function DoFs = Get_DoFs_For_Component(obj,DoFs,Comp)
%Get_DoFs_For_Component
%
%   This returns a list of Degree-of-Freedom (DoF) indices in the finite element
%   (FE) space.  The DoFs correspond to a specific tuple component.
%
%   DoFs = obj.Get_DoFs_For_Component(DoFs,Comp);
%
%   DoFs = list of given DoFs.
%   Comp = tuple component to shift DoFs by (a row vector of length 1 or 2,
%          depending on the tuple-size of the FE space).
%          Note: DoFs are shifted by the corresponding linear index component!

% Copyright (c) 03-26-2018,  Shawn W. Walker

if isempty(DoFs)
    return;
end

Comp = obj.Process_Tuple_Component(Comp);
LI   = obj.LinearInd(Comp);

% shift DoF indices based on the tuple component
Num_Scalar_Global_DoF = obj.max_dof;
DoFs = DoFs + (LI-1) * Num_Scalar_Global_DoF;

end