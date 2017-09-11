% FELICITY Class for testing FELICITY code
%
%   obj  = FELtest(Name);
%
%   Name = (string) name of the testing.
classdef FELtest
    properties %(SetAccess='private',GetAccess='private')
        Name          % name of testing.
    end
    methods
        function obj = FELtest(varargin)
            
            if nargin ~= 1
                disp('Requires 1 argument!');
                disp('First  is a name.');
                error('Check the arguments!');
            end
            
            OUT_str  = '|---> Init FELtest Object...';
            disp(OUT_str);
            
            obj.Name           = varargin{1};
            if ~ischar(obj.Name)
                error('Name must be a string.');
            end
%             obj.Text = []; % init
%             obj.ENDL = '\n';
        end
    end
end

% END %