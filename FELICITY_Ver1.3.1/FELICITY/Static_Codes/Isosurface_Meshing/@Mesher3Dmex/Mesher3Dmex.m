% FELICITY MATLAB class wrapper for the TIGER mesh generator (3-D meshes)
%
%   Generate 3-D tetrahedral meshes that conform to an isosurface.
%
%   obj = Mesher3Dmex(Box_Dim,Num_Lattice_Points,Use_Newton,TOL);
%
%   Box_Dim             = 1x2 matrix: dimensions of one edge of the rectangular box (hexahedron);
%                                     other two orthogonal edges have the same dimensions.
%   Num_Lattice_Points  = number of points (along one dimension) to use for the BCC grid.
%   Use_Newton          = true/false: use Newton's method for finding cut points.
%   TOL                 = tolerance to use in computing the cut points.
%
%   Alternative calling procedure when making an "outer" mesh, and you want
%   the outer boundary to not be jagged.
%
%   obj = Mesher3Dmex(Box_Dim,Num_Lattice_Points,Use_Newton,TOL,Exact_Cube);
%
%   Exact_Cube = (true/false) indicates whether the background grid should
%                be for an exact cube.  Warning: of the isosurface of your
%                domain comes too close to the boundary of the cube, then
%                the min and max dihedral angles are no longer guaranteed.
%                In that case, just use a bigger cube.

% Copyright (c) 03-10-2020,  Shawn W. Walker
classdef Mesher3Dmex
    properties %(SetAccess = private)
        Box_Dim
        Num_Points
        Tolerance
        Use_Newton         % boolean indicating whether to use Newton's method
                           %     or bisection when computing intersections with
                           %     the zero level set
        LS
        bcc_mesh
        cut_info
    end
    methods
        function obj = Mesher3Dmex(varargin)
            
            if or(nargin < 4,nargin > 5)
                disp('Requires 4 (or 5) arguments!');
                disp('First  is the side dimensions of cube [a, b].');
                disp('Second is the number of points (along 1-D) to use in BCC grid.');
                disp('Third  is boolean indicating the root finding method: true = Newton''s Method, false = bisection.');
                disp('Fourth is the tolerance to use in computing the cut points.');
                disp('Fifth (optional) is boolean indicating whether the background box should be an *exact* cube.');
                error('Check the arguments!');
            end
            
            obj.Box_Dim          = varargin{1};
            obj.Num_Points       = varargin{2};
            obj.Use_Newton       = varargin{3};
            if isempty(obj.Use_Newton)
                obj.Use_Newton = false; % default to bisection
            end
            obj.Tolerance        = varargin{4};
            % when Newton's method is used (true), the convergence criteria is:
            %               |f(x_k)| < tolerance,
            % where f is the level set function value. Good value to use: 1e-12.
            % when bisection is used (false), the convergence criteria is:
            %               |[a_k, b_k]| < tolerance,
            % where [a_k, b_k] is the bisection bracket relative to a BCC mesh
            % edge (so this is a relative tolerance).  Good value to use: 1e-2.
            if isempty(obj.Tolerance)
                if obj.Use_Newton
                    obj.Tolerance = 1e-12;
                else
                    obj.Tolerance = 1e-2;
                end
            end
            
            if nargin==4
                Exact_Cube = false;
            else
                Exact_Cube = varargin{5};
            end
            
            obj.LS               = []; % init
            obj.bcc_mesh         = []; % init
            obj.cut_info         = []; % init
            if Exact_Cube
                obj.bcc_mesh = bcc_tetrahedral_cube(obj.Box_Dim,obj.Num_Points);
            else
                obj.bcc_mesh = bcc_tetrahedral_mesh(obj.Box_Dim,obj.Box_Dim,obj.Box_Dim,...
                                                    obj.Num_Points,obj.Num_Points,obj.Num_Points);
                %
            end
        end
    end
end

% END %