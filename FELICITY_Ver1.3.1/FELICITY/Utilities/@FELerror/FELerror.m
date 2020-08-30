% FELICITY Class for displaying nice error messages
%
%   obj  = FELerror;
classdef FELerror
    properties %(SetAccess='private',GetAccess='private')
        Error_Comment        % struct containing all of the log comments
        STD_LINE             % default line break
        STD_ERROR            % default error print statement
        DEBUG                % indicates whether to put debugging code in
        ENDL                 % end line character
    end
    methods
        function obj = FELerror(varargin)
            
            if nargin ~= 0
                disp('Requires 0 arguments!');
                error('Check the arguments!');
            end
            
            obj.DEBUG                 = true;
            obj.ENDL                  = '\n';
            
            % init output statements
            obj.STD_LINE  = '========================================================================';
            obj.STD_ERROR = 'ERROR detected:';
            obj.Error_Comment(1).str = obj.STD_LINE;
            obj.Error_Comment(2).str = obj.STD_ERROR;
            obj.Error_Comment(3).str = ' ';
        end
    end
end

% END %