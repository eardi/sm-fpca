% FELICITY Class for storing and manipulating a reference finite element, i.e.
% manage local basis functions, topological entities, etc.
%
%   obj      = ReferenceFiniteElement(Elem,Num_Comp);
%
%   Elem     = struct containing element information.  See the directory:
%              './FELICITY/Elem_Defn' for examples.
%   Num_Comp = number of tensor components to the basis function,
%              (i.e. tensor products of scalar valued basis functions).
%
%   obj      = ReferenceFiniteElement(Elem,Num_Comp,DEBUG);
%
%   DEBUG    = (boolean) indicates whether or not to perform debugging checks.
classdef ReferenceFiniteElement
    properties %(SetAccess='private',GetAccess='private')
        Top_Dim           % dimension of the reference domain
        Simplex_Type      % string indicating type of simplex domain
        Simplex_Vtx       % vertices of simplex
        Element_Type      % string indicating continuous or DIScontinuous galerkin
        Element_Name      % string indicating name of finite element space
                          % e.g. 'brezzi-douglas-marini-deg-2'
        Element_Degree    % i.e. the polynomial degree, or function degree.
        %Num_Func          % in the future need to add a Num_Func field to
                          %    keep track of distinct functions that are
                          %    concatenated together (e.g. velocity/pressure)
        Num_Comp          % number of tensor components
        Num_Vec_Comp      % number of intrinsic components
        Num_Basis         % Number of local basis functions
        Basis             % struct containing info about local basis functions in
                          % symbolic form
        Transformation    % string indicating the type of transformation to use (i.e. H^1, H(div), etc...)
        Nodal_BC_Coord    % the local barycentric coordinates of each nodal DoF
        Nodal_Top         % the nodal DoF topological arrangement
        DEBUG             % indicates whether or not to perform debugging checks
    end
    methods
        function obj = ReferenceFiniteElement(varargin)
            
            if or(nargin < 2,nargin > 3)
                disp('Requires 2 or 3 arguments!');
                disp('First  is a struct holding the element information.');
                disp('Second is a positive integer specifying the number of tensor components.');
                disp('(optional) Third  is a boolean indicating whether or not to perform debugging things.');
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
            obj.Num_Vec_Comp = [];
            obj.Num_Basis = [];
            obj.Basis = [];
            obj.Nodal_BC_Coord = [];
            obj.Nodal_Top = [];
            
            obj = Read_In_Element_Struct(obj,ELEM);
            
            obj.Num_Comp = 1; % default
            if and(~isempty(varargin{2}),varargin{2} > 1)
                obj.Num_Comp = round(varargin{2});
            end
            if (nargin==2)
                obj.DEBUG = false; % default
            elseif or(~varargin{3},isempty(varargin{3}))
                obj.DEBUG = false;
            else
                obj.DEBUG = true;
            end
        end
    end
end

% END %