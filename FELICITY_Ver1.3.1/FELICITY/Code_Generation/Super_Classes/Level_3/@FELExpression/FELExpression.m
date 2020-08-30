% Abstract Class for dealing with expressions and generating code.
% This is meant to be used with generating code for evaluating integrands and
% interpolation expressions.
classdef FELExpression
    properties %(SetAccess='private',GetAccess='private')
        Name                 % name of this particular object
        Snippet_Dir          % directory to hold snippets files
        DEBUG                % indicates whether to put debugging code in
    end
    methods
        function obj = FELExpression(varargin)
            
            if nargin ~= 2
                disp('Requires 2 arguments!');
                disp('First   is a name for this.');
                disp('Second  is the temporary snippet directory to use.');
                error('Check the arguments!');
            end
            
            obj.Name                 = varargin{1};
            obj.Snippet_Dir          = varargin{2};
            if ~ischar(obj.Name)
                error('Name should be a string.');
            end
            if ~FEL_isfolder(obj.Snippet_Dir)
                error('Snippet directory does not exist!');
            end
            obj.DEBUG    = true;
        end
    end
end

% END %