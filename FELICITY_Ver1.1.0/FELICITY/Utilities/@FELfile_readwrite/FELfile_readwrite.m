% FELICITY Class for reading/writing FELICITY text/data/code files
%
%   obj  = FELfile_readwrite(FileName);
%
%   FileName = (string) file name that you want to use.
%
% SWW: does this class need to be removed?
classdef FELfile_readwrite
    properties %(SetAccess='private',GetAccess='private')
        FileName             % string containing full file location
        Text                 % struct containing lines of text (read or to be written)
    end
    methods
        function obj = FELfile_readwrite(varargin)
            
            if nargin ~= 1
                disp('Requires 1 argument!');
                disp('First  is a file name.');
                error('Check the arguments!');
            end
            
            OUT_str  = '|---> Init FELfile_readwrite Object...';
            disp(OUT_str);
            
            obj.FileName           = varargin{1};
            if ~ischar(obj.FileName)
                error('FileName must be a string.');
            end
            D = dir(obj.FileName);
            if isempty(D)
                error('FileName not found.');
            end
            if isdir(obj.FileName)
                error('Input was only a directory.  Also need the FileName!');
            end
            obj.Text = []; % init
        end
    end
end

% END %