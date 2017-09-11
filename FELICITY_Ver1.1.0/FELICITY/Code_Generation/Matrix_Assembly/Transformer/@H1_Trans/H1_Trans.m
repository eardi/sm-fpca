% class for computing (symbolically) the natural map for H^1 functions.
% functions in this class may be tensor valued, with each component being a
% scalar function in H^1:
%       f(x) = f^hat (x^hat),    x = PHI(x^hat), x^hat are ``local'' coordinates.
% All quantities are computed with respect to x, e.g. \nabla_x f(x), but are
% expressed in local coordinates, i.e. \nabla_x f(PHI(x^hat))
% Note: we only care about how a scalar function transforms, b/c all other
% components transform the same way.
classdef H1_Trans < generic_trans
    properties %(SetAccess=private,GetAccess=private)
        GeoMap         % a Geometric_Trans object.
        f              % this is a structure variable containing
                       %      the function, its derivatives, and other stuff.
        INTERPOLATION     % boolean indicating if this is for interpolating FEM functions
                          % false = (default) assume normal FEM matrix assembly
                          % true  = assume this is for generating code for interpolation
    end
    methods
        function obj = H1_Trans(varargin)
            
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