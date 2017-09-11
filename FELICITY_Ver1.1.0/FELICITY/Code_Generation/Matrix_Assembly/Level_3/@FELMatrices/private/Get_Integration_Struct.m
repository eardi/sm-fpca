function Integration = Get_Integration_Struct()
%Get_Integration_Struct
%
%   This sets the FE integration matrix struct for storing important info.

% Copyright (c) 06-01-2012,  Shawn W. Walker

% init
Integration.Domain = []; % record the integration domain
Integration.Matrix = []; % Map container holding FELMatrix objects

end