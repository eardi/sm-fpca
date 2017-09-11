% (FELICITY) Class that represents a Domain of integration (or expression) and
%    all other required embeddings in order to evaluate integrals defined on the
%    Domain of Integration (or expression).  This is necessary for assembling
%    over subdomains, OR for performing interpolation of FEM functions.
classdef FELDomain
    properties %(SetAccess='private',GetAccess='private')
        Global             % Level 1 Domain info for global domain (i.e. global mesh)
        Subdomain          % Level 1 Domain info for an intermediate subdomain contained in Global
        Integration_Domain % Level 1 Domain info for the integration domain contained in Subdomain
        IS_CURVED          % specifies whether straight or higher order (global) meshes are used
        Num_Quad           % number of quad points to use on the integration domain
        BEGIN_Auto_Gen
        END_Auto_Gen
        % Subdomain is the intrinsic domain; Integration_Domain is where we
        % restrict the Subdomain.
    end
    methods
        function obj = FELDomain(varargin)
            
            if nargin ~= 5
                disp('Requires 5 arguments!');
                disp('First  input is the global Domain.');
                disp('Second input is the subdomain Domain.');
                disp('Third  input is the integration Domain.');
                disp('Fourth input is whether the mesh is curved (higher) order or just linear.');
                disp('Fifth  input is number of quad points to use for integrating on the integration Domain.');
                error('Check the arguments!');
            end
            
            OUT_str  = '|---> Init FELDomain Object...';
            disp(OUT_str);
            
            obj.Global = varargin{1};
            if ~isa(obj.Global,'Domain')
                error('Global must be a Level 1 Domain!');
            end
            obj.Subdomain = varargin{2};
            if ~isa(obj.Subdomain,'Domain')
                error('Subdomain must be a Level 1 Domain!');
            end
            obj.Integration_Domain = varargin{3};
            if ~isa(obj.Integration_Domain,'Domain')
                error('Integration_Domain must be a Level 1 Domain!');
            end
            if (obj.Global.Top_Dim < obj.Subdomain.Top_Dim)
                error('Global domain cannot have a smaller topological dimension than the Subdomain.');
            end
            if (obj.Subdomain.Top_Dim < obj.Integration_Domain.Top_Dim)
                error('Subdomain cannot have a smaller topological dimension than the Integration_Domain.');
            end
            Subdomain_Subset_Of_Global = or(strcmp(obj.Subdomain.Subset_Of,obj.Global.Name),...
                                            isequal(obj.Subdomain,obj.Global));
            Integration_Subset_Of_Global = or(strcmp(obj.Integration_Domain.Subset_Of,obj.Global.Name),...
                                              isequal(obj.Integration_Domain,obj.Global));
            if ~and(Subdomain_Subset_Of_Global,Integration_Subset_Of_Global)
                error('Both Subdomain and Integration_Domain must be subsets of the Global domain!');
            end
            if ~and(obj.Global.GeoDim==obj.Subdomain.GeoDim,obj.Global.GeoDim==obj.Integration_Domain.GeoDim)
                error('GeoDim of domains must all be the same!');
            end
            
            obj.IS_CURVED = varargin{4};
            if ~islogical(obj.IS_CURVED)
                error('Invalid!');
            end
            obj.Num_Quad = varargin{5};
            if (obj.Num_Quad < 1)
                error('Invalid!');
            end
            
            obj.BEGIN_Auto_Gen = '/*------------ BEGIN: Auto Generate ------------*/';
            obj.END_Auto_Gen   = '/*------------   END: Auto Generate ------------*/';
        end
    end
end

% END %