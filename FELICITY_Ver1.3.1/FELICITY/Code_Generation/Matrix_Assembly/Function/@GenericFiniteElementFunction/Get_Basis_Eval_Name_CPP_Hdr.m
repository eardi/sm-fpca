function CPP_Name_Hdr = Get_Basis_Eval_Name_CPP_Hdr(obj,Vec_Comp)
%Get_Basis_Eval_Name_CPP_Hdr
%
%   This returns the C++ *HEADER* name to use for storing evaluations of
%   the basis functions (in the generated code).  The evaluations are at
%   the quadrature points.
%
%   Input is the vector component **(in the C-style of indexing! Starting
%   from 0.)**; note that this does **not** refer to the tensor component!
%   This is the "vector" component, like H(div) is vector valued.
%
%   The output looks like:  'phi_0'

% Copyright (c) 10-25-2016,  Shawn W. Walker

HDR_str = 'phi'; % set this as the default

% create the standard basis function eval C++ name header
if isempty(Vec_Comp)
    CPP_Name_Hdr = HDR_str;
else
    CPP_Name_Hdr = [HDR_str, '_', num2str(Vec_Comp)];
end

end