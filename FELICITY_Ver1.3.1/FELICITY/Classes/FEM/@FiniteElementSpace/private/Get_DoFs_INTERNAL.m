function DoFs = Get_DoFs_INTERNAL(obj,DoFs_scalar,ARG)
%Get_DoFs_INTERNAL
%
%   This returns a list of Degree-of-Freedom (DoF) indices in the finite element
%   (FE) space.  Depending on the options passed, this may return only the
%   *scalar* DoFs (i.e. the DoFs for the first component of a tuple-valued FE space),
%   or it may return the DoFs for a specified tuple component.
%
%   DoFs = obj.Get_DoFs_INTERNAL(DoFs_scalar,[]);
%
%   DoFs_scalar = Rx1 list of given DoFs for the 1st component of the FE space.
%   DoFs = same as DoFs_scalar.
%
%   DoFs = obj.Get_DoFs_INTERNAL(DoFs_scalar,Comp);
%
%   Comp = tuple component to shift DoFs by (a row vector of length 1 or 2,
%          depending on the tuple-size of the FE space).
%          Note: DoFs are shifted by the corresponding linear index component!
%
%   DoFs_scalar = same as above.
%   DoFs = DoFs_scalar shifted by the linear index corresponding to Comp.
%
%   DoFs = obj.Get_DoFs_INTERNAL(DoFs_scalar,'all');
%
%   DoFs = similar to above, except DoFs is an RxC matrix, where C is the
%          *total* number of components in the tuple-valued space, and
%          column k = i + (j-1)*M, where (i,j) is the tuple index pair
%          into the (block) cartesian product FE space of tuple-size M x N.

% Copyright (c) 03-26-2018,  Shawn W. Walker

if isempty(ARG)
    ARG = [1, 1]; % default to the first component
end

if strcmpi(ARG,'all')
    % return all DoFs for all tuple components
    DoFs = zeros(length(DoFs_scalar),prod(obj.Num_Comp));
    for ci_1 = 1:obj.Num_Comp(1)
        for ci_2 = 1:obj.Num_Comp(2)
            LI = sub2ind(obj.Num_Comp,ci_1,ci_2);
            DoFs(:,LI) = obj.Get_DoFs_For_Component(DoFs_scalar,[ci_1, ci_2]);
        end
    end
else
    % just return one component
    Comp = ARG;
    DoFs = obj.Get_DoFs_For_Component(DoFs_scalar,Comp);
end

end