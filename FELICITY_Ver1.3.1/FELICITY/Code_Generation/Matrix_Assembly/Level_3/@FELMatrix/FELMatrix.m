% Class for Arrays of FEM Matrices (FELICITY Matrix Language)
% Contains info about the domain of integration (DoI), as well as the integrand
% itself.  This generates code for computing the local FE matrix.
classdef FELMatrix < FELExpression
    properties %(SetAccess='private',GetAccess='private')
        Integral_str         % string describing the integral that is implemented
        Num_SubMAT           % number of sub-matrices
        SubMAT               % struct containing info about the sub-matrices
        SubMAT_Computation_Order % array of sub-matrix indices in order of evaluation
        Tab_Tensor_Code      % filename that contains the "Tabulate_Tensor" sub-routine
        row_func             % FiniteElementBasisFunction (for row space)
        col_func             % FiniteElementBasisFunction (for col space)
        row_func_str         % string representing the outside variable name
        col_func_str         % string representing the outside variable name
        row_constant_space   % used for storing info for C++ code to generate a CONSTANT basis function
        col_constant_space   % used for storing info for C++ code to generate a CONSTANT basis function
    end
    methods
        function obj = FELMatrix(varargin)
            
            if nargin ~= 8
                disp('Requires 8 arguments!');
                disp('First   is a name for the finite element matrix.');
                disp('Second  is a string holding the integral description.');
                disp('Third   is the number of sub-matrices.');
                disp('Fourth  is the row function.');
                disp('Fifth   is the col function.');
                disp('Sixth   is a string representing the outside variable name of the row function.');
                disp('Seventh is a string representing the outside variable name of the col function.');
                disp('Eighth  is the temporary snippet directory to use.');
                error('Check the arguments!');
            end
            
            obj = obj@FELExpression(varargin{1},varargin{8});
            OUT_str  = '|---> Init FELMatrix Object...';
            disp(OUT_str);
            
            obj.Integral_str         = varargin{2};
            obj.Num_SubMAT           = varargin{3};
            obj.SubMAT_Computation_Order = []; % will be set later...
            obj.Tab_Tensor_Code      = []; % will be set later...
            obj.row_func             = varargin{4};
            obj.col_func             = varargin{5};
            obj.row_func_str         = varargin{6};
            obj.col_func_str         = varargin{7};
            obj.row_constant_space   = [];
            obj.col_constant_space   = [];
            
            if ~ischar(obj.Integral_str)
                error('Integral_str should be a string.');
            end
            if obj.Num_SubMAT < 1
                error('Number of sub-matrices must be at least 1.');
            end
            
            if isempty(obj.row_func)
                obj.row_func = FiniteElementBasisFunction('',[],'CONST',[]);
            end
            if ~isa(obj.row_func,'FiniteElementBasisFunction')
                error('row_func must be a FiniteElementBasisFunction!');
            end
            
            if isempty(obj.col_func)
                obj.col_func = FiniteElementBasisFunction('',[],'CONST',[]);
            end
            if ~isa(obj.col_func,'FiniteElementBasisFunction')
                error('col_func must be a FiniteElementBasisFunction!');
            end
                
            if ~ischar(obj.row_func_str)
                error('row_func_str should be a string.');
            end
            if ~ischar(obj.col_func_str)
                error('col_func_str should be a string.');
            end
            
            obj.SubMAT   = Get_SubMAT_struct();
            for index = 2:obj.Num_SubMAT
                obj.SubMAT(index)   = Get_SubMAT_struct();
            end
            % setup info for CONSTANT function spaces
            if strcmp(obj.row_func.Elem.Element_Name,'constant_one')
                obj.row_constant_space.CPP_Var   = [obj.Name, '_row_constant_phi'];
                obj.row_constant_space.Num_Comp  = 1; % default for Bilinear and Linear forms
            end
            if strcmp(obj.col_func.Elem.Element_Name,'constant_one')
                obj.col_constant_space.CPP_Var   = [obj.Name, '_col_constant_phi'];
                obj.col_constant_space.Num_Comp  = 1; % default for Bilinear and Linear forms
            end
        end
    end
end

% END %