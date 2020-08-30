% (FELICITY) Class for Arrays of Point Searches
% This class collects all the Domains to do Point Searches on into a Map container
classdef FELPointSearches
    properties %(SetAccess='private',GetAccess='private')
        keys            % keys to GeomFuncs (MAP)
        GeomFuncs       % MAP of GeometricElementFunctions, each representing a domain to
                        % do point searches on
        DEBUG           % indicates whether to put debugging code in
    end
    methods
        function obj = FELPointSearches(varargin)
            
            if nargin ~= 2
                disp('Requires 2 arguments!');
                disp('First  is a ReferenceFiniteElement for the Global domain geometry.');
                disp('Second is an array of FELDomain(s) (each one we are point searching on).');
                error('Check the arguments!');
            end
            
            OUT_str  = '|---> Init FELPointSearches Object...';
            disp(OUT_str);
            
            Geom_Elem     = varargin{1};
            if ~isa(Geom_Elem,'ReferenceFiniteElement')
                error('Geom_Elem must be a ReferenceFiniteElement for the global geometry.');
            end
            Search_Domain = varargin{2};
            
            obj.GeomFuncs = containers.Map; % init
            for ind = 1:length(Search_Domain)
                if ~isa(Search_Domain(ind),'FELDomain')
                    error('Domain must be a FELDomain!');
                end
                TEMP_Domain = Search_Domain(ind); % init
                % we only care about the geometry of the domain and
                % how it is embedded in the Global mesh.
                TEMP_Domain.Subdomain = TEMP_Domain.Integration_Domain;
                % for simplicity: make sure the subdomain IS the integration domain!
                
                % create geometry representation for computing Jacobians, etc...
                % of the map that represents the domain embedded in the Global mesh
                GF = GeometricElementFunction(Geom_Elem,TEMP_Domain);
                % set options necessary for performing point searches
                GF = Set_GeomFunc_Options(GF);
                obj.GeomFuncs(GF.Domain.Subdomain.Name) = GF; % store it
            end
            obj.keys = obj.GeomFuncs.keys;
            
            % set
            obj.DEBUG  = true;
        end
    end
end

% END %