% class for processing Level 1 - FELICITY FEM Interpolation DSL scripts
% this changes level 1 code, through a level 2 struct, into what I call level 3
% MATLAB objects.
classdef Interp_L1toL3
    properties %(SetAccess=private,GetAccess=private)
        INTERP
    end
    methods
        function obj = Interp_L1toL3(varargin)
            
            if nargin ~= 1
                disp('Requires 1 argument!');
                disp('First  is an Interpolations object.');
                error('Check the arguments!');
            end
            
            obj.INTERP = varargin{1};
            
            if ~isa(obj.INTERP,'Interpolations')
                error('Input must be of type ''Interpolations''.');
            end
        end
    end
end

% END %