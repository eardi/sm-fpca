% FELICITY (abstract) class for processing level 1 user code.
%
%   obj        = expression_collection(GeoElem);
%
%   GeoElem    = GeoElement that specifies how the domain (mesh) geometry is represented.
classdef expression_collection
    properties %(SetAccess=private,GetAccess=private)
        GeoElem           % this stores how the geometry (domain) is represented.
        C_Codes           % struct containing filename info for C-Code to include.
    end
    methods
        function obj = expression_collection(varargin)
            
            if (nargin ~= 1)
                disp('Requires 1 argument!');
                disp('First  is a GeoElement.');
                error('Check the arguments!');
            end
            
            obj.GeoElem      = varargin{1};
            obj.C_Codes      = [];
            
            if ~isa(obj.GeoElem,'GeoElement')
                error('First argument must be a GeoElement!');
            end
        end
    end
end

% END %