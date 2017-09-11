function Integration = Get_Integration_Struct()
%Get_Integration_Struct
%
%   This sets the FE integration domain struct for storing important info.

% Copyright (c) 05-26-2012,  Shawn W. Walker

% special GeometricElementFunction for the geometric representation of the
%         Domain of Integration (DoI)
Integration.DoI_Geom     = [];

Integration.BasisFunc    = []; % Map container holding FiniteElementBasisFunctions
Integration.CoefFunc     = []; % Map container holding FiniteElementCoefFunctions
Integration.GeomFunc     = []; % Map container holding GeometricElementFunctions

end