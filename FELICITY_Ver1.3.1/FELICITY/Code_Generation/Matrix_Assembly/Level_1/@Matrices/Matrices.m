% FELICITY class for processing level 1 user code.
% This defines a Matrices object.  This is for collecting all the Forms together
% and outputting it to the code generation routines.
%
%   obj        = Matrices(Quad_Order,GeoElem);
%
%   Quad_Order = positive integer representing the quadrature order to use when
%                generating code to assemble matrices.
%   GeoElem    = GeoElement that specifies how the global domain (mesh) geometry
%                is represented.
classdef Matrices < expression_collection
    properties %(SetAccess=private,GetAccess=private)
        Quad_Order        % positive integer representing the quadrature order to use.
        Matrix_Data       % this stores (multiple) matrix defn(s).
    end
    methods
        function obj = Matrices(varargin)
            
            if (nargin ~= 2)
                disp('Requires 2 arguments!');
                disp('First  is a positive integer representing the quadrature order.');
                disp('Second is a GeoElement.');
                error('Check the arguments!');
            end
            
            obj = obj@expression_collection(varargin{2});
            
            obj.Quad_Order   = varargin{1};
            obj.GeoElem.Name = inputname(2);
            obj.Matrix_Data  = [];
            
            if (obj.Quad_Order < 1)
                error('Quadrature order must be >= 1!');
            end
        end
    end
end

% END %