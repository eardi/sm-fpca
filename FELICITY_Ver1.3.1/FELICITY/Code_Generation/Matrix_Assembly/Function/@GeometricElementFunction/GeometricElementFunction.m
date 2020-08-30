% (FELICITY) Class for Geometric Element Functions
% The .Elem field is the reference finite element for the global geometry, i.e.
% the GLOBAL mesh that contains ALL subdomains.
% The .Domain field contains a FELDomain:
%                 .Global
%                 .Subdomain
%                 .Integration_Domain
% The following inclusion relation holds:
% Integration_Domain  \subset  Subdomain  \subset  Global,
% where "=" may replace "\subset".
% Example: a FE space may be defined on the Subdomain, and Integration_Domain
% may be a lower dimensional subset in Subdomain.  The geometric map must be
% built from the GLOBAL representation!  This requires obtaining the intrinsic
% map for Subdomain, \PHI, (computed from Global) then restricting \PHI to the
% Integration_Domain.
classdef GeometricElementFunction < GenericFiniteElementFunction
    properties %(SetAccess='private',GetAccess='private')
        Domain            % a FELDomain
        GeoTrans          % Geometric_Trans object
        CPP               % struct containing info about C++ data type names (identifiers)
    end
    methods
        function obj = GeometricElementFunction(varargin)
            
            if nargin ~= 2
                disp('Requires 2 arguments!');
                disp('First  is a copy of the reference finite element for the global geometry.');
                disp('Second is a FELDomain describing the kind of domain geometry.');
                error('Check the arguments!');
            end
            
            OUT_str  = '|---> Init GeometricElementFunction Object...';
            disp(OUT_str);
            
            % set the default function name to 'geom'
            % Note: a more specific name is created in obj.GeoTrans
            FN = 'geom'; % default geometry prefix
            obj = obj@GenericFiniteElementFunction(varargin{1},FN);
            
            obj.Domain = varargin{2};
            if isempty(obj.Domain)
                % this object isn't really used just yet.
                obj.GeoTrans = [];
                obj.Opt = [];
                obj.CPP = Get_CPP_struct();
                return;
            end
            if ~isa(obj.Domain,'FELDomain')
                error('Domain must be a FELDomain!');
            end
            
            % create transformer object
            obj = obj.Create_Transformer;
            % init
            obj.Opt = obj.Get_Opt_struct();
            obj.CPP = Get_CPP_struct();
            obj = Determine_CPP_Info(obj);
        end
    end
end

% END %