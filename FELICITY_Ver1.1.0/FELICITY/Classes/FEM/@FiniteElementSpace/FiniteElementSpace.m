% FELICITY Class for storing and manipulating a Finite Element Space.
%
%   obj     = FiniteElementSpace(Name,RefElem,Mesh,SubName);
%
%   Name    = (string) name for the Finite Element (FE) space.
%   RefElem = object of class ReferenceFiniteElement.
%   Mesh    = FELICITY mesh object (MeshInterval, MeshTriangle, or MeshTetrahedron).
%   SubName = (string) name of the mesh subdomain on which the FE space is defined.
%             if SubName = [], then FE space is defined on global mesh.
classdef FiniteElementSpace
    properties (SetAccess='private')
        Name              % name for what the finite element space represents
        RefElem           % ReferenceFiniteElement object
        Mesh_Info         % struct containing information about the mesh on which the finite element space is defined
        DoFmap            % local-to-global element map (for the first tensor component only)
        Fixed             % array of structs (length = number of components of FE space)
                          % each struct has one field = .Domain, which is a...
                          % ...cell array of subdomain names where the DoFs are fixed (e.g. a Dirichlet condition)
                          % Note: by default,  all DoFs are assumed to be free.
    end
    methods
        function obj = FiniteElementSpace(varargin)
            
            if nargin ~= 4
                disp('Requires 4 arguments!');
                disp('First  is an appropriate name for the Finite Element Space.');
                disp('Second is a ReferenceFiniteElement object.');
                disp('Third  is a FELICITY mesh object (MeshInterval, MeshTriangle, or MeshTetrahedron).');
                disp('Fourth is the name of the mesh subdomain on which the FE Space is defined.');
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
            
            % init
            obj.DoFmap    = [];
            obj.Fixed.Domain = {};
            for ii = 2:obj.RefElem.Num_Comp
                obj.Fixed(ii).Domain = {};
            end
            
            obj.Mesh_Info = Mesh_Info_Struct;
            obj = Get_Mesh_Info(obj,varargin{3},varargin{4});
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
end

% END %