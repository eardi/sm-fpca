function DoFs = Get_DoFs_For_Component(obj,DoFs,Comp)
%Get_DoFs_For_Component
%
%   This returns a list of Degree-of-Freedom (DoF) indices in the finite element
%   (FE) space.  The DoFs correspond to a specific tensor component.
%
%   DoFs = obj.Get_DoFs_For_Component(DoFs,Comp);
%
%   DoFs = list of given DoFs.
%   Comp = tensor component to shift DoFs by.

% Copyright (c) 09-06-2012,  Shawn W. Walker

if isempty(DoFs)
    return;
end

% just return one component
if (length(Comp) > 1) % i.e. a matrix valued space
    error('Not implemented or invalid!');
end
if (Comp > obj.RefElem.Num_Comp)
    error('Component index is greater than the number of components of FE space!');
end

% shift DoF indices based on the tensor component
Num_Scalar_Global_DoF = obj.max_dof;
DoFs = DoFs + (Comp-1) * Num_Scalar_Global_DoF;

end