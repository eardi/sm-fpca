% (FELICITY) Class for Arrays of Interpolations
% This class collects all the Interpolations into a Map container
classdef FELInterpolations
    properties %(SetAccess='private',GetAccess='private')
        keys            % keys to Interp (MAP)
        Interp          % MAP of FELInterpolate objects containing info about
                        % evaluating expressions and the domains of the expression
        Snippet_Dir     % directory to put minor code snippets
        DEBUG           % indicates whether to put debugging code in
    end
    methods
        function obj = FELInterpolations(varargin)
            
            if nargin ~= 1
                disp('Requires 1 argument!');
                disp('First  is a string representing a sub-directory to store code snippets.');
                error('Check the arguments!');
            end
            
            OUT_str  = '|---> Init FELInterpolations Object...';
            disp(OUT_str);
            
            obj.keys   = cell(0);        % init
            obj.Interp = containers.Map; % init
            
            obj.Snippet_Dir = varargin{1};
            if ~ischar(obj.Snippet_Dir)
                error('Snippet sub-directory must be a string!');
            end
            % set
            obj.DEBUG  = true;
        end
    end
end

% END %