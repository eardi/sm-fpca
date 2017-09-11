% class for creating code to compute basis functions on embedded subdomains
% with codimension >= 0.
classdef Codim_Map
    properties (SetAccess=private)%,GetAccess=private)
        Domain
        Num_Quad
    end
    methods
        function obj = Codim_Map(varargin)
            
            if (nargin ~= 1)
                disp('Requires 1 arguments!');
                disp('A GeometricElementFunction object representing the subdomain parameterization.');
                error('Check the arguments!');
            end
            
            GeomFunc = varargin{1};
            if ~isa(GeomFunc,'GeometricElementFunction')
                error('This must be a GeometricElementFunction object!');
            end
            
            obj.Domain   = GeomFunc.Domain;
            obj.Num_Quad = GeomFunc.Domain.Num_Quad;
        end
    end
end

% END %