% class for computing (symbolically) the natural map for constants.
%
% There is almost nothing to do here.  This is just to be consistent with
% the other transformation classes.  This is only meant to be used with the
% "constant_one" element, which is for representing a global constant on a
% sub-domain.  Note: I do *not* mean piecewise constants!

% constant in this class may be tuple-valued, with each component being a
% number.
classdef Constant_Trans < generic_trans
    properties %(SetAccess=private,GetAccess=private)
        C              % this is a structure variable containing
                       %    the constant, and other stuff.
        INTERPOLATION     % boolean indicating if this is for interpolating FEM functions
                          % false = (default) assume normal FEM matrix assembly
                          % true  = assume this is for generating code for interpolation
    end
    methods
        function obj = Constant_Trans(varargin)
            
            if or((nargin < 1),(nargin > 2))
                disp('Requires 1 argument! (second argument is ignored.)');
                disp('First is the name of the constant, C.');
                error('Check the arguments!');
            end
            
            obj = obj@generic_trans(varargin{1}); % name of the function (string)
            obj.INTERPOLATION = false; % assume no interpolation is being done
            % initialize the function
            obj = init_func(obj);
        end
    end
end

% END %