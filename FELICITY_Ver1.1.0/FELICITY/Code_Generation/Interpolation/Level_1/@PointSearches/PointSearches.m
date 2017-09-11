% FELICITY class for processing level 1 user code.
% This defines a PointSearches object.  This is for collecting all Domains (to be
% searched) and giving it to the code generation routines.
%
%   obj        = PointSearches(GeoElem);
%
%   GeoElem    = GeoElement that specifies how the global domain (mesh) geometry
%                is represented.
classdef PointSearches < expression_collection
    properties %(SetAccess=private,GetAccess=private)
        Search_Domain       % this stores (multiple) Domain objects.
    end
    methods
        function obj = PointSearches(varargin)
            
            if (nargin ~= 1)
                disp('Requires 1 argument!');
                disp('First  is a GeoElement.');
                error('Check the arguments!');
            end
            
            obj = obj@expression_collection(varargin{1});
            obj.GeoElem.Name = inputname(1);
            obj.Search_Domain  = [];
        end
    end
end

% END %