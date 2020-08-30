% FELICITY Class for storing and manipulating a Finite Element Space.
%
%   obj     = FiniteElementSpace(Name,RefElem,Mesh,SubName,Num_Comp);
%
%   Name     = (string) name for the Finite Element (FE) space.
%   RefElem  = object of class ReferenceFiniteElement.
%   Mesh     = FELICITY mesh object (MeshInterval, MeshTriangle, or MeshTetrahedron).
%   SubName  = (string) name of the mesh subdomain on which the FE space is defined.
%              if SubName = [], then FE space is defined on the global mesh.
%   Num_Comp = (optional) number of tuple components for the finite element
%              space (i.e. spaces can be built by taking cartesian products
%              of base FE spaces). If omitted, then the default value
%              "[1, 1]" is used.
%              NOTE: If Num_Comp = [M], then
%                    if the base FE space is scalar valued, then functions
%                    in the FE space are column vectors of length M.
%                    If Num_Comp = [M, N], then
%                    if the base FE space is scalar valued, then functions
%                    in the FE space are matrices of size M x N.
%
%   obj     = FiniteElementSpace(Name,RefElem,Mesh,SubName,Num_Row,Num_Col);
%
%             Same as previous with Num_Comp = [Num_Row, Num_Col].
classdef FiniteElementSpace
    properties (SetAccess='private')
        Name              % name for what the finite element space represents
        RefElem           % ReferenceFiniteElement object
        Mesh_Info         % struct containing information about the mesh on which the finite element space is defined
        Num_Comp          % number of tuple components of the vector or matrix-valued basis functions
        DoFmap            % local-to-global element map (for the first tensor component only)
        Fixed             % array of structs (length = number of components of FE space)
                          % each struct has one field = .Domain, which is a...
                          % ...cell array of subdomain names where the DoFs are fixed (e.g. a Dirichlet condition)
                          % Note: by default,  all DoFs are assumed to be free.
    end
    methods
        function obj = FiniteElementSpace(varargin)
            
            if or(nargin < 4,nargin > 6)
                disp('Requires 4, 5, or 6 arguments!');
                disp('First  is an appropriate name for the Finite Element Space.');
                disp('Second is a ReferenceFiniteElement object.');
                disp('Third  is a FELICITY mesh object (MeshInterval, MeshTriangle, or MeshTetrahedron).');
                disp('Fourth is the name of the mesh subdomain on which the FE Space is defined.');
                disp('(optional) Fifth/Sixth is the tuple-size of cartesian products of the ReferenceFiniteElement.');
                error('Check the arguments!');
            end
            
            OUT_str  = '|---> Init FiniteElementSpace Object...';
            disp(OUT_str);
            
            obj.Name     = varargin{1};
            obj.RefElem  = varargin{2};
            
            if ~ischar(obj.Name)
                error('Name is not a string!');
            end
            if ~isa(obj.RefElem,'ReferenceFiniteElement')
                error('RefElem must be a ReferenceFiniteElement!');
            end
            
            obj.Mesh_Info = Mesh_Info_Struct;
            obj = Get_Mesh_Info(obj,varargin{3},varargin{4});
            
            obj.Num_Comp = [1, 1]; % default
            if (nargin==5)
                TC = varargin{5};
                if (size(TC,1)~=1)
                    error('5th argument must be a row vector.');
                end
                if (size(TC,2) > 2)
                    error('5th argument must be a row vector of length 1 or 2.');
                end
                if (size(TC,2)==1)
                    TC = [TC(1), 1];
                end
                obj.Num_Comp = TC;
            end
            if (nargin==6)
                TC_1 = varargin{5};
                TC_2 = varargin{6};
                TC = [TC_1, TC_2];
                if ~and(size(TC,1)==1,size(TC,2)==2)
                    error('5th and 6th argument must each be a scalar.');
                end
                obj.Num_Comp = TC;
            end
            if (min(obj.Num_Comp) < 1)
                error('Tuple component sizes must be >= 1!');
            end
            
            % init
            obj.DoFmap = [];
            obj.Fixed(obj.Num_Comp(1),obj.Num_Comp(2)).Domain = {};
        end
    end
    methods (Access = public)
        function MAX = max_dof(obj)
            %max_dof
            %
            %   This returns the largest Degree-of-Freedom (DoF) index in
            %   obj.DoFmap.  Note: this is only for the 1st component of the
            %   space; this is important when the FE space is a tensor product
            %   of other FE spaces.
            %
            %   MAX = obj.max_dof;
            MAX = max(obj.DoFmap(:));
        end
        function MIN = min_dof(obj)
            %min_dof
            %
            %   This returns the smallest Degree-of-Freedom (DoF) index in
            %   obj.DoFmap.  Note: this is only for the 1st component of the
            %   space; this is important when the FE space is a tensor product
            %   of other FE spaces.
            %
            %   MIN = obj.min_dof;
            MIN = min(obj.DoFmap(:));
        end
        function NUM = num_dof(obj)
            %num_dof
            %
            %   This returns the number of unique Degree-of-Freedom (DoF)
            %   indices in obj.DoFmap.  Note: this is only for the 1st component
            %   of the space; this is important when the FE space is a tensor
            %   product of other FE spaces.
            %
            %   NUM = obj.num_dof;
            NUM = length(unique(obj.DoFmap(:)));
        end
    end
    methods (Access = protected)
        function status = Verify_Mesh(obj,Mesh)
            status = obj.Verify_Mesh_INTERNAL(Mesh);
        end
    end
end

% END %