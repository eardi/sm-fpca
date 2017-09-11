% (FELICITY) Class for Finite Element Coefficient Functions
% this is meant to be an object inside FELSpaces
classdef FiniteElementCoefFunction < GenericFiniteElementFunction
    properties %(SetAccess='private',GetAccess='private')
        Space_Name           % string containing name of finite element space
        FuncTrans            % Transformer object
        CPP_Data_Type        % data type name for the code generation
        CPP_Var              % variable name in C++
    end
    methods
        function obj = FiniteElementCoefFunction(varargin)
            
            if (nargin ~= 4)
                disp('Requires 4 arguments!');
                disp('First  is a name for the finite element space.');
                disp('Second is a copy of the reference finite element.');
                disp('Third  is a name for the function.');
                disp('Fourth is a GeometricElementFunction.');
                error('Check the arguments!');
            end
            
            OUT_str  = '|---> Init FiniteElementCoefFunction Object...';
            disp(OUT_str);
            obj = obj@GenericFiniteElementFunction(varargin{2},varargin{3});
            if ~ischar(obj.Func_Name)
                error('Func_Name must be a string.');
            end
            obj.Space_Name   = varargin{1};
            GeomFunc         = varargin{4};
            if ~isa(GeomFunc,'GeometricElementFunction')
                error('GeomFunc must be a GeometricElementFunction!');
            end
            if ~ischar(obj.Space_Name)
                error('FE Space name must be a string!');
            end
            % create coef function variable name
            obj.CPP_Var = [obj.Func_Name, '_restricted_to_', GeomFunc.Domain.Integration_Domain.Name];
            obj.CPP_Data_Type = ['Data_Type_', obj.CPP_Var];
            
            % create transformer object
            obj.FuncTrans = [];
            obj = obj.Create_Transformer(GeomFunc);
            % init
            obj.Opt = obj.Get_Opt_struct;
        end
    end
end

% END %