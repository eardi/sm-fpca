function DoFs = Get_DoFs_INTERNAL(obj,DoFs_scalar,ARG)
%Get_DoFs_INTERNAL
%
%   This returns a list of Degree-of-Freedom (DoF) indices in the finite element
%   (FE) space.  Depending on the options passed, this may return only the
%   *scalar* DoFs (i.e. the DoFs for the first component of a tensor FE space),
%   or it may return the DoFs for a specified tensor component.
%
%   DoFs = obj.Get_DoFs_INTERNAL(DoFs_scalar,[]);
%
%   DoFs_scalar = list of given DoFs for the 1st component of the FE space.
%   DoFs = same as DoFs_scalar.
%
%   DoFs = obj.Get_DoFs_INTERNAL(DoFs_scalar,Comp);
%
%   DoFs_scalar = list of given DoFs for the 1st component of the FE space.
%   Comp = tensor component to shift DoFs by.
%
%   DoFs = DoFs_scalar shifted by Comp.
%
%   DoFs = obj.Get_DoFs_INTERNAL(DoFs_scalar,'all');
%
%   DoFs = similar to above, except DoFs is an MxC matrix, where C is the number
%          of components in the tensor-valued space, and column j corresponds to
%          component j.

% Copyright (c) 09-06-2012,  Shawn W. Walker

if isempty(ARG)
    ARG = 1; % default to the first component
end

if strcmpi(ARG,'all')
    % return all DoFs for all tensor components
    DoFs = zeros(length(DoFs_scalar),obj.RefElem.Num_Comp);
    for ci = 1:obj.RefElem.Num_Comp
        DoFs(:,ci) = obj.Get_DoFs_For_Component(DoFs_scalar,ci);
    end
else
    % just return one component
    Comp = ARG;
    DoFs = obj.Get_DoFs_For_Component(DoFs_scalar,Comp);
end

end