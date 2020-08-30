% FELICITY MATLAB class wrapper for a Quadtree C++ class
%
%   obj  = mexQuadtree(Points);
%   obj  = mexQuadtree(Points,Bounding_Box);
%   obj  = mexQuadtree(Points,Bounding_Box,Max_Tree_Levels);
%   obj  = mexQuadtree(Points,Bounding_Box,Max_Tree_Levels,Bucket_Size);
%
%   Points          = Mx2 matrix representing the coordinates of the points to be
%                     partitioned by the quadtree.
%   Bounding_Box    = bounding box dimensions of the points:
%                     1x4 vector [X_min, X_max, Y_min, Y_max].
%   Max_Tree_Levels = maximum number of tree levels to use in the quadtree.
%   Bucket_Size     = the number of points to store in each leaf cell of the quadtree.

% Copyright (c) 01-14-2014,  Shawn W. Walker
classdef mexQuadtree < mexAbstracttree
    methods
        % Constructor
        function obj = mexQuadtree(varargin)
            
            if or((nargin < 1),(nargin > 4))
                disp('Requires 1 to 4 arguments!');
                disp('First  is the point coordinates (Mx2 matrix).');
                disp('Second is the bounding box dimensions for the points: 1x4 vector [X_min, X_max, Y_min, Y_max].');
                disp('Third  is the maximum number of tree levels to use in the quadtree.');
                disp('Fourth is the bucket size to use for the number of points to store in each leaf cell.');
                error('Check the arguments!');
            end
            % first use base constructor
            obj = obj@mexAbstracttree(varargin{1:end}); % split up the inputs
            
            % check Bounding_Box
            if ~and(size(obj.Bounding_Box,1)==1,size(obj.Bounding_Box,2)==4)
                error('Bounding box must be a 1x4 row vector.');
            end
            
            % Quadtree:
            obj.cppMEX = str2func('mexQuadtree_CPP');
            obj.dim    = 2; % space dimension is 2
            
            if (size(obj.Points,2)~=2)
                error('Points must have 2 columns (dimension = 2)!');
            end
            % get bounding box of points
            Min_X = min(obj.Points(:,1));
            Max_X = max(obj.Points(:,1));
            Min_Y = min(obj.Points(:,2));
            Max_Y = max(obj.Points(:,2));
            if (nargin >= 2) % verify user bounding box against points
                BB = [Min_X, Max_X, Min_Y, Max_Y];
                BAD_BOX = (obj.Bounding_Box(1) > BB(1)) || (obj.Bounding_Box(2) < BB(2)) ||...
                          (obj.Bounding_Box(3) > BB(3)) || (obj.Bounding_Box(4) < BB(4));
                if (BAD_BOX)
                    disp('The user''s bounding box is:');
                    obj.Bounding_Box
                    disp('The actual bounding box of the points is:');
                    BB
                    disp('The user must specify a bounding box that *contains* the points!');
                    error('Check your inputs!');
                end
            else
                X_Diff = Max_X - Min_X;
                Y_Diff = Max_Y - Min_Y;
                % set bounding box coordinates to be slightly larger (default)
                obj.Bounding_Box = [Min_X - (0.001*X_Diff), Max_X + (0.001*X_Diff),...
                                    Min_Y - (0.001*Y_Diff), Max_Y + (0.001*Y_Diff)];
            end
            
            % now create an instance of the C++ class
            % note: this will build the tree from the given points
            obj.cppHandle = obj.cppMEX('new',obj.Points,obj.Bounding_Box,obj.Max_Tree_Levels,obj.Bucket_Size);
        end
    end
end

% END %