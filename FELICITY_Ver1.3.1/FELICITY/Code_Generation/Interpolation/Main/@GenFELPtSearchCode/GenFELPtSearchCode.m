% Class for Auto Generating Point Searching Code
classdef GenFELPtSearchCode < Generic_GenFELCode
    properties %(SetAccess='private',GetAccess='private')
    end
    methods
        function obj = GenFELPtSearchCode(varargin)
            
            if nargin ~= 2
                disp('Requires 2 arguments!');
                disp('First  is a string containing the directory where the generated code is placed.');
                disp('Second is a struct of parameters.');
                error('Check the arguments!');
            end
            
            obj = obj@Generic_GenFELCode(varargin{1},varargin{2});
            OUT_str  = '|---> Init GenFELPtSearchCode Object...';
            disp(OUT_str);
            
            obj.Skeleton_Dir  = Get_Skeleton_Dir();
            if ~ischar(obj.Skeleton_Dir)
                error('Input should be a string!');
            end
            if ~isdir(obj.Skeleton_Dir)
                error('Input is not a valid directory!');
            end
        end
    end
end

% END %