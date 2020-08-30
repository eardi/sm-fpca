% (FELICITY) Class for Arrays of Finite Element Spaces
% This class collects all the FE spaces into a Map container, and it collects
% all info for the domains of integration (DoI).  Moreover, on each DoI, a
% collection of basis functions (corresponding directly to the collection of FE
% spaces) is stored.  This basis function information is used for actual
% computations (via code generation) like mapping basis functions, restricting
% basis functions to integration domains that are contained in the domain of
% definition of the FE space.
% Note: this class is also used for interpolation where domains of integration
% are actually domains of expression.
classdef FELSpaces
    properties %(SetAccess='private',GetAccess='private')
        Space                % Map container with info about the FE spaces
        Integration          % (array) of structs containing info about different domains of integration
        DEBUG                % indicates whether to put debugging code in
    end
    methods
        function obj = FELSpaces(varargin)
            
            if nargin ~= 2
                disp('Requires 2 arguments!');
                disp('First  is a FELDomain.');
                disp('Second is a ReferenceFiniteElement representing the geometry of the Hold-All domain.');
                error('Check the arguments!');
            end
            
            OUT_str  = '|---> Init FELSpaces Object...';
            disp(OUT_str);
            
            % init
            obj.Space    = containers.Map;
            
            DOM = varargin{1};
            Geom_Elem = varargin{2};
            obj.Integration = Get_Integration_Struct(); % init
            for ind = 1:length(DOM)
                if ~isa(DOM(ind),'FELDomain')
                    error('Domain must be a FELDomain!');
                end
                TEMP_Domain = DOM(ind); % init
                % make a special modification for the domain of integration,
                % i.e. we do not care about any FE basis function space here; we
                % only care about the geometry of the domain of integration and
                % how it is embedded in the Global mesh.
                TEMP_Domain.Subdomain = TEMP_Domain.Integration_Domain;
                % make sure the subdomain IS the integration domain!
                
                % store geometry representation that is only concerned with
                % computing Jacobians, etc... of the map that represents the
                % domain of integration embedded in the Global mesh
                obj.Integration(ind).DoI_Geom  = GeometricElementFunction(Geom_Elem,TEMP_Domain);
                
                obj.Integration(ind).BasisFunc = containers.Map; % init
                obj.Integration(ind).CoefFunc  = containers.Map; % init
                obj.Integration(ind).GeomFunc  = containers.Map; % init
            end
            % BasisFunc has key values corresponding to the Space_Names
            % CoefFunc  has key values corresponding to the Coef Function Names
            % GeomFunc  has key values corresponding to the Domain Names, e.g. key=Gamma.
            
            % set
            obj.DEBUG                = true;
        end
    end
end

% END %