% class for computing (symbolically) the local-to-global element map
%       i.e. for computing the jacobian, inverse, etc...
%       this also handles outputting C-code to compute these things!
classdef Geometric_Trans < generic_trans
    % let PHI denote the vector map from local to global coordinates
    %     number of components is the geometric dimension of the domain.
    %     it is a function of d variables, where d is the topological dimension.
    % this map describes (locally) the geometry of the physical domain.
    properties %(SetAccess=private,GetAccess=private)
        GeoDim            % ambient geometric dimension (of domain)
        TopDim            % intrinsic topological dimension (of domain)
        PHI               % this is a structure variable containing
                          %      the map, and its derivatives, and other stuff.
        Lin_PHI_TF        % boolean indicating if the map is a linear function
                          %      this is useful because derivatives of the map
                          %      are CONSTANT.  This makes the generated code
                          %      more efficient.
    end
    methods
        function obj = Geometric_Trans(varargin)

            if (nargin ~= 4)
                disp('Requires 4 arguments!');
                disp('First  is the name of the map.');
                disp('Second is the (ambient) geometric dimension of the domain.');
                disp('Third  is the (intrinsic) topological dimension of the domain.');
                disp('Fourth is true/false indicating if the map is linear.');
                error('Check the arguments!');
            end
            
            obj = obj@generic_trans(varargin{1}); % name for the map (string)
            obj.GeoDim      = varargin{2};
            obj.TopDim      = varargin{3};
            obj.Lin_PHI_TF  = varargin{4};
            if or((obj.GeoDim <= 0),(obj.TopDim <= 0))
                error('Dimensions must be positive!');
            end
            if (obj.GeoDim > 3)
                error('Not implemented!');
            end
            if (obj.TopDim > 3)
                error('Not implemented!');
            end
            if (obj.GeoDim < obj.TopDim)
                error('Geometric dimension must not be less than topological dimension.');
            end
            if ~islogical(obj.Lin_PHI_TF)
                error('Lin_PHI_TF must be true or false.');
            end
            % initialize the map
            obj = init_map(obj);
        end
    end
end

% END %