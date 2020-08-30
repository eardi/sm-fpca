% class for computing (symbolically) the Piola transform for H(div) functions.
% functions in this class are vector valued:
%           J = [\nabla_{x^hat} PHI(x^hat)]
%       vv(x) = (1/det(J)) J vv^hat(x^hat), where
%           x = PHI(x^hat), x^hat are ``local'' coordinates.
% Note: in principle, one can have tensor products of these H(div) functions.
% but we only care about how "one component" transforms.
% All quantities are computed with respect to x, e.g. \nabla_x vv(x), but are
% expressed in local coordinates, i.e. \nabla_x vv(PHI(x^hat))
classdef Hdiv_Trans < generic_trans
    properties %(SetAccess=private,GetAccess=private)
        GeoMap            % a Geometric_Trans object.
        vv                % this is a structure variable containing
                          %      the function, its derivatives, etc.
        INTERPOLATION     % boolean indicating if this is for interpolating FEM functions
                          % false = (default) assume normal FEM matrix assembly
                          % true  = assume this is for generating code for interpolation
    end
    methods
        function obj = Hdiv_Trans(varargin)
            
            if (nargin ~= 2)
                disp('Requires 2 arguments!');
                disp('First  is the name of the function, f.');
                disp('Second is a Geometric_Trans object representing the local element map PHI.');
                error('Check the arguments!');
            end
            
            obj = obj@generic_trans(varargin{1}); % name of the function (string)
            obj.GeoMap = varargin{2};
            if ~isa(obj.GeoMap,'Geometric_Trans')
                error('GeoMap must be a Geometric_Trans object!');
            end
            obj.INTERPOLATION = false; % assume no interpolation is being done
            % initialize the function
            obj = init_func(obj);
        end
    end
end

% END %