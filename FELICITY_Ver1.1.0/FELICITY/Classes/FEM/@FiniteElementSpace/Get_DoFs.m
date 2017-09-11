function DoFs = Get_DoFs(obj,ARG)
%Get_DoFs
%
%   This returns a list of Degree-of-Freedom (DoF) indices in the finite element
%   (FE) space.  Depending on the options passed, this may return only the
%   *scalar* DoFs (i.e. the DoFs for the first component of a tensor-valued FE
%   space), or it may return the DoFs for a specified tensor component.
%
%   DoFs = obj.Get_DoFs;
%
%   DoFs = is an (increasing) ordered array (length M) of unique DoF indices in
%          obj.DoFmap.
%          Note: this is only for the 1st component of a tensor-valued space.
%
%   DoFs = obj.Get_DoFs(Comp);
%
%   DoFs = similar to above, except DoFs corresponds to a specific tensor
%          component specified by 'Comp'.
%
%   DoFs = obj.Get_DoFs('all');
%
%   DoFs = similar to above, except DoFs is an MxC matrix, where C is the number
%          of components in the tensor-valued space, and column j corresponds to
%          component j.

% Copyright (c) 09-06-2012,  Shawn W. Walker

% get list of ALL (scalar) DoF indices in FE space
DoFs_scalar = unique(obj.DoFmap(:));

if (nargin==1)
    ARG = [];
end
Check_ARG(ARG);
DoFs = obj.Get_DoFs_INTERNAL(DoFs_scalar,ARG);

end