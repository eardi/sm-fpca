% FELICITY Class for storing and manipulating a Finite Element Space that
% specifies mesh geometry.
%
%   obj      = GeoElementSpace(Name,RefElem,Mesh);
%
%   Name     = (string) name for the Geo- Element (FE) space.
%   RefElem  = object of class ReferenceFiniteElement.
%   Mesh     = FELICITY mesh object (MeshInterval, MeshTriangle, or MeshTetrahedron).
classdef GeoElementSpace < FiniteElementSpace
    properties (SetAccess='private')
        mex_Dir           % directory to put mex file
        mex_Interpolation % function handle to mex interpolation routine
    end
    methods
        function obj = GeoElementSpace(varargin)
            
            if nargin ~= 3
                disp('Requires 3 arguments!');
                disp('First  is an appropriate name for the Geo-Element Space.');
                disp('Second is a ReferenceFiniteElement object.');
                disp('Third  is a FELICITY mesh object (MeshInterval, MeshTriangle, or MeshTetrahedron).');
                error('Check the arguments!');
            end
            
            OUT_str  = '|---> Init GeoElementSpace Object...';
            disp(OUT_str);
            
            Mesh = varargin{3};
            obj = obj@FiniteElementSpace(varargin{1},varargin{2},Mesh,[],Mesh.Geo_Dim);
            
            obj.mex_Dir = []; % init
            
            % define the mex file name
            func_str = ['mex_Interpolate_in_GeoElementSpace_', obj.Name, '_INTERNAL'];
            obj.mex_Interpolation = str2func(func_str); % init
        end
    end
end

% END %