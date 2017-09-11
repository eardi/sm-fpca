% Class for Arrays of Finite Element Spaces (FELICITY Matrix Language)
classdef FELCoefs
    properties %(SetAccess='private',GetAccess='private')
        Num_Funcs            % number of (coefficient) functions contained here
        Func                 % struct containing info about the (coefficient) functions
        DEBUG                % indicates whether to put debugging code in
    end
    methods
        function obj = FELCoefs(varargin)
            
            if nargin ~= 0
                disp('Requires 0 arguments!');
                error('Check the arguments!');
            end
            
            OUT_str  = '|---> Init FELCoefs Object...';
            disp(OUT_str);
            
            obj.Num_Funcs            = 0;
            % init
            obj.Func.CPP_Data_Type_Name  = [];
            obj.Func.CPP_Var_Name        = [];
            obj.Func.Space_Index         = [];
            obj.Func.Coef                = [];
            obj.Func.Coef_str            = [];
            % set
            obj.DEBUG                    = true;
        end
    end
end

% END %