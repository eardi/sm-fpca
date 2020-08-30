function FS = Setup_FELGeoms(obj,FS)
%Setup_FELGeoms
%
%   This inits the GeomFunc Map container under FS.Integration(ind).GeomFunc.

% Copyright (c) 01-23-2014,  Shawn W. Walker

Num_Distinct_Integration_Domains = length(FS.Integration);
for ind = 1:Num_Distinct_Integration_Domains
    % geometry representation for the domain of integration
    DoI_GF = FS.Integration(ind).DoI_Geom;
    Current_Integration_Domain = DoI_GF.Domain.Integration_Domain;
    
    % look thru all the matrices
    Num_Matrix = length(obj.MATS.Matrix_Data);
    for mi = 1:Num_Matrix
        ID = obj.MATS.Matrix_Data{mi}.Integral;
        % search the integrals!
        for kk = 1:length(ID)
            % if the integral domain matches the current Integration_Domain
            if isequal(ID(kk).Domain,Current_Integration_Domain)
                % include any extra geometric functions
                for gi = 1:length(ID(kk).GeoF)
                    % get the domain we are interested in
                    Extra_Geom_Domain = ID(kk).GeoF(gi).Domain;
                    % create the object
                    GF = create_valid_extra_geom_func(DoI_GF,Extra_Geom_Domain);
                    if ~isempty(GF)
                        Geom_Domain_Name = GF.Domain.Subdomain.Name;
                        FS.Integration(ind).GeomFunc(Geom_Domain_Name) = GF; % insert!
                    end
                end
            end
        end
    end
end

% note: don't worry if a GeometricElementFunction gets overwritten; they are
% all on the same domain of integration!

end

function GeomFunc = create_valid_extra_geom_func(DoI_Geom,Extra_Geom_Domain)
%
%   This creates a GeometricElementFunction for the domain of integration with
%   respect to containment in the domain for which we want geometric information, i.e.
%   the Subdomain.
%
%          New_Domain.Global             = global mesh domain.
%          New_Domain.Subdomain          = domain corresponding to the geometric data
%                                          that we are interested in.
%          New_Domain.Integration_Domain = where to evaluate the geometric data.
%
%   Note: DoI_Geom is the geometric function representing the geometry of
%   the Global mesh/domain and how the domain of integration is embedded.

% Copyright (c) 01-23-2014,  Shawn W. Walker

New_Domain = DoI_Geom.Domain; % init
% set the Subdomain to be the domain where the geometric data is
New_Domain.Subdomain = Extra_Geom_Domain;

Extra_Geom_Domain_TopDim = Extra_Geom_Domain.Top_Dim;
DoI_TopDim = New_Domain.Integration_Domain.Top_Dim;

if (DoI_TopDim > Extra_Geom_Domain_TopDim)
    % this is not a valid domain embedding, so return NULL
    GeomFunc = [];
else
    GeomFunc  = GeometricElementFunction(DoI_Geom.Elem,New_Domain);
end

end