% FELICITY class for processing level 1 user code.
% This defines an Interpolations object.  This is for collecting all Interpolate objects
% and giving it to the code generation routines.
%
%   obj        = Interpolations(GeoElem);
%
%   GeoElem    = GeoElement that specifies how the global domain (mesh) geometry
%                is represented.
classdef Interpolations < expression_collection
    properties %(SetAccess=private,GetAccess=private)
        Interp_Expr       % this stores (multiple) Interpolate objects.
    end
    methods
        function obj = Interpolations(varargin)
            
            if (nargin ~= 1)
                disp('Requires 1 argument!');
                disp('First  is a GeoElement.');
                error('Check the arguments!');
            end
            
            obj = obj@expression_collection(varargin{1});
            obj.GeoElem.Name = inputname(1);
            obj.Interp_Expr  = [];
        end
    end
end

% END %