% FELICITY Class for logging data
%
%   obj  = FELLog(Dir,FileName,Description,DEBUG);
%
%   Dir         = (string) directory where to store log file.
%   FileName    = (string) file name for log file.
%   Description = (string) text describing what the log file is for.
%   DEBUG       = (boolean) indicates whether 'debug mode' is on or off.
classdef FELLog
    properties %(SetAccess='private',GetAccess='private')
        Default_Dir          % set the directory to write log files to
        Default_FileName     % set the filename  to write log files to
        Log_Comment          % struct containing all of the log comments
        DEBUG                % indicates whether to put debugging code in
        ENDL                 % end line character
    end
    methods
        function obj = FELLog(varargin)
            
            if nargin ~= 4
                disp('Requires 4 arguments!');
                disp('First  is a string for the directory containing the log file.');
                disp('Second is a string for the filename  containing the log file.');
                disp('Third  is a string describing the contents of the log file.');
                disp('Fourth is a boolean indicating whether DEBUG mode is on.');
                error('Check the arguments!');
            end
            
            OUT_str  = '|---> Init FELLog Object...';
            disp(OUT_str);
            
            obj.Default_Dir           = varargin{1};
            obj.Default_FileName      = varargin{2};
            Log_Description           = varargin{3};
            obj.DEBUG                 = varargin{4};
            obj.ENDL                  = '\n';
            
            if ~ischar(obj.Default_Dir)
                error('Default_Dir must be a string.');
            end
            if ~isdir(obj.Default_Dir)
                error('Default_Dir is not a valid directory.');
            end
            if ~ischar(obj.Default_FileName)
                error('Default_FileName must be a string.');
            end
            if ~islogical(obj.DEBUG)
                error('DEBUG must be true or false!');
            end
            
            % init log comments
            STD_LINE = '---------------------------------------------------';
            obj.Log_Comment(1).str = {0, ['START OF LOG FILE', obj.ENDL, STD_LINE]};
            DESCR = ['Description: ' Log_Description];
            obj.Log_Comment(2).str = {0, [DESCR, obj.ENDL, STD_LINE, obj.ENDL]};
        end
    end
end

% END %