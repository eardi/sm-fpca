function GeomFunc = Create_Valid_BasisFunc_GeomFunc(DoI_Geom,Space_Struct)
%Create_Valid_BasisFunc_GeomFunc
%
%   This creates a GeometricElementFunction for the domain of integration with
%   respect to containment in the domain on which the FE space is defined, i.e.
%   the Subdomain.
%
%          New_Domain.Global             = global mesh domain
%          New_Domain.Subdomain          = domain of FE space
%          New_Domain.Integration_Domain = where to evaluate basis functions
%
%   Note: DoI_Geom is the geometric function representing the geometry of
%   the Global mesh/domain and how the domain of integration is embedded.

% Copyright (c) 05-28-2012,  Shawn W. Walker

New_Domain = DoI_Geom.Domain; % init
% set the Subdomain to be the domain where the FE space is defined
FE_Space_Domain      = Space_Struct.Domain;
New_Domain.Subdomain = FE_Space_Domain;

FE_Space_Domain_TopDim = FE_Space_Domain.Top_Dim;
DoI_TopDim = New_Domain.Integration_Domain.Top_Dim;

if (DoI_TopDim > FE_Space_Domain_TopDim)
    % this is not a valid domain embedding, so return NULL
    GeomFunc  = [];
else
    GeomFunc  = GeometricElementFunction(DoI_Geom.Elem,New_Domain);
end

end