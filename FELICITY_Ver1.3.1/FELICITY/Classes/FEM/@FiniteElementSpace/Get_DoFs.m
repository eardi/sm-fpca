function DoFs = Get_DoFs(obj,ARG)
%Get_DoFs
%
%   This returns a list of Degree-of-Freedom (DoF) indices in the finite element
%   (FE) space.  Depending on the options passed, this may return only the
%   *scalar* DoFs (i.e. the DoFs for the first component of a tuple-valued FE
%   space), or it may return the DoFs for a specified tuple component.
%
%   DoFs = obj.Get_DoFs;
%
%   DoFs = is an (increasing) ordered array (length R) of unique DoF indices in
%          obj.DoFmap.
%          Note: this is only for the 1st component of a tuple-valued space.
%
%   DoFs = obj.Get_DoFs(Comp);
%
%   DoFs = similar to above, except DoFs corresponds to a specific tuple
%          component specified by 'Comp', which is a row vector of length
%          1 or 2 depending on the tuple-size of the FE space.
%          Note: DoFs are shifted by the corresponding linear index version
%          of 'Comp'.
%
%   DoFs = obj.Get_DoFs('all');
%
%   DoFs = similar to above, except DoFs is an RxC matrix, where C is the
%          *total* number of components in the tuple-valued space, and
%          column k = i + (j-1)*M, where (i,j) is the tuple index pair
%          into the (block) cartesian product FE space of tuple-size M x N.

% Copyright (c) 03-26-2018,  Shawn W. Walker

% get list of ALL DoF indices in the BASE FE space (the one that we take
% the cartesian product of).
DoFs_scalar = unique(obj.DoFmap(:));

if (nargin==1)
    ARG = [];
end
Check_ARG(ARG);
DoFs = obj.Get_DoFs_INTERNAL(DoFs_scalar,ARG);

end