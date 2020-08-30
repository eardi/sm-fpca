% FELICITY Class that interfaces to FELICITY's code generation
%
%   obj  = FELInterface(Dir);
%
%   Dir = (string) main directory to work in.
classdef FELInterface
    properties %(SetAccess='private',GetAccess='private')
        Main_Dir           % the main directory to work in
    end
    methods
        function obj = FELInterface(varargin)
            
            if nargin ~= 1
                disp('Requires 1 arguments!');
                disp('First  is a string containing the main directory to work in.');
                error('Check the arguments!');
            end
            
            OUT_str  = '|---> Init FELInterface Object...';
            disp(OUT_str);
            
            obj.Main_Dir = varargin{1};
            
            if ~ischar(obj.Main_Dir)
                error('Input is not a string!');
            end
            if ~isdir(obj.Main_Dir)
                error('Input is not a valid directory!');
            end
        end
    end
end

% END %