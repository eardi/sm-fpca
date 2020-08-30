% (FELICITY) Class for Finite Element Basis Functions
% this is meant to be an object inside FELSpaces
classdef FiniteElementBasisFunction < GenericFiniteElementFunction
    properties %(SetAccess='private',GetAccess='private')
        Space_Name           % string containing name of finite element space
        Type                 % string describing the type of function
        GeomFunc             % geometric function for this basis function
        FuncTrans            % Transformer object(s)
        CPP_Data_Type        % data type name for the code generation
        CPP_Var              % variable name in C++
    end
    methods
        function obj = FiniteElementBasisFunction(varargin)
            
            if and(nargin ~= 4,nargin ~= 1)
                disp('Requires 4 arguments!');
                disp('First  is a name for the finite element space.');
                disp('Second is a copy of the reference finite element.');
                disp('Third  is a string describing the type of function:');
                disp('          ''Test''');
                disp('          ''Trial''');
                disp('          ''Basis''');
                disp('          ''CONST''');
                disp('Fourth is a GeometricElementFunction.');
                disp(' OR ');
                disp('Requires 1 argument!');
                disp('First  is a copy of the reference finite element.');
                error('Check the arguments!');
            end
            
            if (nargin==4)
                CONST         = strcmp(varargin{3},'CONST');
                
                SpaceName     = varargin{1};
                Elem          = varargin{2};
                my_Type       = varargin{3};
                Func_Name     = [SpaceName, '_phi'];
                my_GeomFunc   = varargin{4};
            else
                CONST         = false;
                SpaceName     = '';
                Elem          = varargin{1};
                Func_Name     = 'phi_Basis_Val';
                my_Type       = 'Basis';
                my_GeomFunc   = [];
            end
            if CONST
                SpaceName    = '';
                Elem         = varargin{2};
                Func_Name    = '';
                my_Type      = 'CONST';
                my_GeomFunc  = [];
            end
            if isempty(Elem)
                Elem = ReferenceFiniteElement(constant_one(),true);
            end
            obj = obj@GenericFiniteElementFunction(Elem,Func_Name);
            obj.Space_Name   = SpaceName;
            obj.Type         = my_Type;
            obj.GeomFunc     = my_GeomFunc;
            if ~ischar(obj.Space_Name)
                error('Space_Name must be a string.');
            end
            
            Test  = strcmp(obj.Type,'Test');
            Trial = strcmp(obj.Type,'Trial');
            Basis = strcmp(obj.Type,'Basis'); % generic
            CHK_TYPE = or(or(or(Test,Trial),Basis),CONST);
            if ~CHK_TYPE
                error('Function Type not properly specified!  Must be either ''Test'', ''Trial'', ''Basis'', or ''CONST''!');
            end
            
            % create basis function variable name
            if ~isempty(obj.GeomFunc)
                obj.CPP_Var = [obj.Func_Name, '_restricted_to_', obj.GeomFunc.Domain.Integration_Domain.Name];
            else
                obj.CPP_Var = [];
            end
            obj.CPP_Data_Type = ['Data_Type_', obj.CPP_Var];
            
            % create transformer object
            obj.FuncTrans = [];
            obj = obj.Create_Transformer(obj.GeomFunc);
            % init
            obj.Opt = obj.Get_Opt_struct;
        end
    end
end

% END %