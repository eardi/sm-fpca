function DOM = Get_CPPdefine_Domain_Name(obj,Domain_Name)
%Get_CPPdefine_Domain_Name
%
%   This returns a struct containing CPP mex name info for the given FEM
%   Interpolation Domain.

% Copyright (c) 01-29-2013,  Shawn W. Walker

% [TF, LOC] = ismember(Domain_Name,obj.Space.keys);
% if ~TF
%     error('Given Domain_Name does not exist!');
% end

DOM.Interp_Data     = [Domain_Name, '_Interp_Data'];
DOM.MEX_Interp_Data = ['PRHS_', DOM.Interp_Data];

end