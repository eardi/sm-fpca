% Class for converting a Level 1 MATLAB script to a MEX file for finite element (FE) stuff
classdef Generic_L1toExecutable
    properties %(SetAccess='private',GetAccess='private')
        Snippet_Dir           % just a temporary directory for storing code snippets
        GenCode_Dir           % where to put the generated interpolation code
        MEXFile_Dir           % where to put the compiled MEX file
        DEBUG                 % indicates whether to put debugging code in
    end
    methods
        function obj = Generic_L1toExecutable(varargin)
            
            if nargin ~= 3
                disp('Requires 3 arguments!');
                disp('First  is the directory location for temporary code snippets.');
                disp('Second is the directory location of the auto-generated code.');
                disp('Third  is the directory location of the compiled MEX file.');
                error('Check the arguments!');
            end
            
            obj.Snippet_Dir          = varargin{1};
            obj.GenCode_Dir          = varargin{2};
            obj.MEXFile_Dir          = varargin{3};
            obj.DEBUG                = true;
            
            if ~ischar(obj.Snippet_Dir)
                obj.Snippet_Dir
                error('Directory should be a string!');
            end
            if ~ischar(obj.GenCode_Dir)
                obj.GenCode_Dir
                error('Directory should be a string!');
            end
            if ~ischar(obj.MEXFile_Dir)
                obj.MEXFile_Dir
                error('Directory should be a string!');
            end
        end
    end
end

% END %