% class for processing Level 1 - FELICITY Matrix Language DSL scripts
% this changes level 1 code, through a level 2 struct, into what I call level 3
% MATLAB objects.
classdef L1toL3
    properties %(SetAccess=private,GetAccess=private)
        MATS
    end
    methods
        function obj = L1toL3(varargin)
            
            if nargin ~= 1
                disp('Requires 1 argument!');
                disp('First  is a Matrices object.');
                error('Check the arguments!');
            end
            
            obj.MATS = varargin{1};
            
            if ~isa(obj.MATS,'Matrices')
                error('Input must be of type ''Matrices''.');
            end
        end
    end
end

% END %