% Class for Auto Generating Finite Element (FE) Codes
classdef Generic_GenFELCode
    properties %(SetAccess='private',GetAccess='private')
        Skeleton_Dir          % directory where repository is stored
        Output_Dir            % where to put the generated code
        Sub_Dir               % struct containing sub-dir names
        Param                 % various parameters
        BEGIN_Auto_Gen        % string
        END_Auto_Gen          % string
        DEBUG                 % indicates whether to put debugging code in
    end
    methods
        function obj = Generic_GenFELCode(varargin)
            
            if nargin ~= 2
                disp('Requires 2 arguments!');
                disp('First  is a string containing the directory where the generated code is placed.');
                disp('Second is a struct of parameters.');
                error('Check the arguments!');
            end
            
            obj.Skeleton_Dir  = []; % set later in the sub-class
            obj.Output_Dir    = varargin{1};
            obj.Sub_Dir       = obj.Get_Sub_Dir();
            obj.Param         = varargin{2};
            obj.Param         = []; % not used... yet.
            obj.DEBUG         = true;
            
            if ~ischar(obj.Output_Dir)
                error('Input should be a string!');
            end
            if ~isdir(obj.Output_Dir)
                error('Input is not a valid directory!');
            end
            
            obj.BEGIN_Auto_Gen = '/*------------ BEGIN: Auto Generate ------------*/';
            obj.END_Auto_Gen   = '/*------------   END: Auto Generate ------------*/';
        end
    end
end

% END %