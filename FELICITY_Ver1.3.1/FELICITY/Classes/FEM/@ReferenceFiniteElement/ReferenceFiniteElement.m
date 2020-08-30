% FELICITY Class for storing and manipulating a reference finite element, i.e.
% manage local basis functions, topological entities, etc.
%
%   obj      = ReferenceFiniteElement(Elem);
%
%   Elem     = struct containing element information.  See the directory:
%              './FELICITY/Elem_Defn' for examples.
%
%   obj      = ReferenceFiniteElement(Elem,NO_SYM);
%
%   USE_SYM  = (boolean) indicates whether or not to use the symbolic
%              computing toolbox.  Note: for code-generation, it is
%              required!  Default is true.
classdef ReferenceFiniteElement
    properties %(SetAccess='private',GetAccess='private')
        Top_Dim           % dimension of the reference domain
        Simplex_Type      % string indicating type of simplex domain
        Simplex_Vtx       % vertices of simplex
        Element_Type      % string indicating continuous or DIScontinuous galerkin
        Element_Name      % string indicating name of finite element space
                          % e.g. 'brezzi-douglas-marini-deg-2'
        Element_Degree    % i.e. the polynomial degree, or function degree.
        %Num_Func         % in the future need to add a Num_Func field to
                          %    keep track of distinct functions that are
                          %    concatenated together (e.g. velocity/pressure)
        Basis_Size        % size of basis function (i.e. matrix size)
        Num_Basis         % number of local basis functions
        Basis             % struct containing info about local basis functions in
                          % symbolic form
        Transformation    % string indicating the type of transformation to use (i.e. H^1, H(div), etc...)
        Nodal_Data        % nodal variable data for all DoFs
        Nodal_Top         % the nodal DoF topological arrangement
        USE_SYM           % indicates whether or not to use the symbolic computing toolbox
    end
    methods
        function obj = ReferenceFiniteElement(varargin)
            
            if or(nargin < 1,nargin > 2)
                disp('Requires 1 or 2 arguments!');
                disp('First  is a struct holding the element information.');
                disp('(optional) Second  is a boolean indicating whether or not to use Symbolic Computing Toolbox.');
                error('Check the arguments!');
            end
            
            ELEM = varargin{1};
            status = Check_Element_Definition(ELEM);
            if (status~=0)
                error('The element struct is not correct!');
            end
            
            % init
            obj.Top_Dim = [];
            obj.Simplex_Type = [];
            obj.Simplex_Vtx  = [];
            obj.Element_Type = [];
            obj.Element_Name = [];
            obj.Element_Degree = [];
            obj.Basis_Size = [];
            obj.Num_Basis = [];
            obj.Basis = [];
            obj.Transformation = [];
            obj.Nodal_Data = [];
            obj.Nodal_Top = [];
            
            % set symbolic computing toolbox availability
            if (nargin==1)
                obj.USE_SYM = true; % default
            elseif isempty(varargin{2})
                obj.USE_SYM = true;
            elseif islogical(varargin{2})
                obj.USE_SYM = varargin{2};
            else
                % what else can happen?
                obj.USE_SYM = true;
            end
            
            obj = Read_In_Element_Struct(obj,ELEM);
        end
    end
end

% END %