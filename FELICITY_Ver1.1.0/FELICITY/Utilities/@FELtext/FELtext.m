% FELICITY Class for reading/writing FELICITY text/data/code files
%
%   obj  = FELtext(Name);
%
%   Name = (string) name for the text manipulation.
classdef FELtext
    properties %(SetAccess='private',GetAccess='private')
        Name                 % string containing info about the stored text lines
        Text                 % struct containing lines of text (read or to be written)
        ENDL                 % end-of-line character
    end
    methods
        function obj = FELtext(varargin)
            
            if nargin ~= 1
                disp('Requires 1 argument!');
                disp('First  is a name.');
                error('Check the arguments!');
            end
            
            obj.Name           = varargin{1};
            if ~ischar(obj.Name)
                error('Name must be a string.');
            end
            obj.Text = []; % init
            obj.ENDL = '\n';
        end
    end
end

% END %