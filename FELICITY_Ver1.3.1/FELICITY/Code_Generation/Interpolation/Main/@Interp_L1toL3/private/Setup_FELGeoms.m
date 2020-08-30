function FS = Setup_FELGeoms(obj,FS)
%Setup_FELGeoms
%
%   This inits the GeomFunc Map container under FS.Integration(ind).GeomFunc.

% Copyright (c) 01-27-2014,  Shawn W. Walker

Num_Distinct_Expression_Domains = length(FS.Integration);
for ind = 1:Num_Distinct_Expression_Domains
    % geometry representation for the domain of expression
    DoE_GF = FS.Integration(ind).DoI_Geom;
    Current_Expression_Domain = FS.Integration(ind).DoI_Geom.Domain.Integration_Domain;
    % look thru all the matrices
    Num_Expr = length(obj.INTERP.Interp_Expr);
    
    for ie = 1:Num_Expr
        %ID = obj.MATS.Matrix_Data{mi}.Integral;
        I_Expr = obj.INTERP.Interp_Expr{ie};
        
        % if the expression domain matches the current Expression_Domain
        if isequal(I_Expr.Domain,Current_Expression_Domain)
            % include any coefficient functions
            for gi = 1:length(I_Expr.GeoF)
                % get the domain we are interested in
                Extra_Geom_Domain = I_Expr.GeoF(gi).Domain;
                % create the object
                GF = create_valid_extra_geom_func(DoE_GF,Extra_Geom_Domain);
                if ~isempty(GF)
                    Geom_Domain_Name = GF.Domain.Subdomain.Name;
                    FS.Integration(ind).GeomFunc(Geom_Domain_Name) = GF; % insert!
                end
            end
        end
    end
end

% note: don't worry if a GeometricElementFunction gets overwritten; they are
% all on the same domain of expression!

end

function GeomFunc = create_valid_extra_geom_func(DoE_Geom,Extra_Geom_Domain)
%
%   This creates a GeometricElementFunction for the domain of expression with
%   respect to containment in the domain for which we want geometric information, i.e.
%   the Subdomain.
%
%          New_Domain.Global             = global mesh domain.
%          New_Domain.Subdomain          = domain corresponding to the geometric data
%                                          that we are interested in.
%          New_Domain.Integration_Domain = where to evaluate the geometric data.
%
%   Note: DoE_Geom is the geometric function representing the geometry of
%   the Global mesh/domain and how the domain of expression is embedded.

% Copyright (c) 01-23-2014,  Shawn W. Walker

New_Domain = DoE_Geom.Domain; % init
% set the Subdomain to be the domain where the geometric data is
New_Domain.Subdomain = Extra_Geom_Domain;

Extra_Geom_Domain_TopDim = Extra_Geom_Domain.Top_Dim;
DoE_TopDim = New_Domain.Integration_Domain.Top_Dim;

if (DoE_TopDim > Extra_Geom_Domain_TopDim)
    % this is not a valid domain embedding, so return NULL
    GeomFunc = [];
else
    GeomFunc  = GeometricElementFunction(DoE_Geom.Elem,New_Domain);
end

end