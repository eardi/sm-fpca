% FELICITY MATLAB class wrapper for the TIGER mesh generator (2-D meshes)
%
%   Generate 2-D triangle meshes that conform to an isocontour.
%
%   obj = Mesher2Dmex(Box_Dim,Num_Lattice_Points,Use_Newton,TOL);
%
%   Box_Dim             = 1x2 matrix: dimensions of one side of the rectangular box;
%                                     other side has the same dimensions.
%   Num_Lattice_Points  = number of points (along one dimension) to use for the BCC grid.
%   Use_Newton          = true/false: use Newton's method for finding cut points.
%   TOL                 = tolerance to use in computing the cut points.

% Copyright (c) 07-31-2014,  Shawn W. Walker
classdef Mesher2Dmex
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
        function obj = Mesher2Dmex(varargin)
            
            if nargin ~= 4
                disp('Requires 4 arguments!');
                disp('First  is the side dimensions of box [a, b].');
                disp('Second is the number of points (along 1-D) to use in BCC grid.');
                disp('Third  is boolean indicating the root finding method: true = Newton''s Method, false = bisection.');
                disp('Fourth is the tolerance to use in computing the cut points.');
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
            
            obj.LS               = []; % init
            obj.bcc_mesh         = []; % init
            obj.cut_info         = []; % init
            obj.bcc_mesh = bcc_triangle_mesh(obj.Box_Dim,obj.Box_Dim,...
                                             obj.Num_Points,obj.Num_Points);
        end
    end
end

% END %