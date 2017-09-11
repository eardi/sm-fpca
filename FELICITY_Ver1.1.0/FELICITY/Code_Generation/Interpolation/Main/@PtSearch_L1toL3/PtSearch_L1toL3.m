% class for processing Level 1 - FELICITY Point Search DSL scripts
% this changes level 1 code, through a level 2 struct, into what I call level 3
% MATLAB objects.
classdef PtSearch_L1toL3
    properties %(SetAccess=private,GetAccess=private)
        PTSEARCH
    end
    methods
        function obj = PtSearch_L1toL3(varargin)
            
            if nargin ~= 1
                disp('Requires 1 argument!');
                disp('First  is a PointSearches object.');
                error('Check the arguments!');
            end
            
            obj.PTSEARCH = varargin{1};
            
            if ~isa(obj.PTSEARCH,'PointSearches')
                error('Input must be of type ''PointSearches''.');
            end
        end
    end
end

% END %