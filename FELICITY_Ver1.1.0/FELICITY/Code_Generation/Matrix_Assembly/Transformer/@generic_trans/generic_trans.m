% class for computing (symbolically) transformations via chain rule
classdef generic_trans
    properties %(SetAccess=private,GetAccess=private)
        Name              % name
    end
    methods
        function obj = generic_trans(varargin)
            
            obj.Name        = varargin{1};
            if ~ischar(obj.Name)
                error('Name must be a string!');
            end
        end
    end
end

% END %