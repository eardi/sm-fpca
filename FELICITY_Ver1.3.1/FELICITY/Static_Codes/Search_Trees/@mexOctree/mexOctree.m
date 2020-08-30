% FELICITY MATLAB class wrapper for a Octree C++ class
%
%   obj  = mexOctree(Points);
%   obj  = mexOctree(Points,Bounding_Box);
%   obj  = mexOctree(Points,Bounding_Box,Max_Tree_Levels);
%   obj  = mexOctree(Points,Bounding_Box,Max_Tree_Levels,Bucket_Size);
%
%   Points          = Mx3 matrix representing the coordinates of the points to be
%                     partitioned by the octree.
%   Bounding_Box    = bounding box dimensions of the points:
%                     1x6 vector [X_min, X_max, Y_min, Y_max, Z_min, Z_max].
%   Max_Tree_Levels = maximum number of tree levels to use in the octree.
%   Bucket_Size     = the number of points to store in each leaf cell of the octree.

% Copyright (c) 01-14-2014,  Shawn W. Walker
classdef mexOctree < mexAbstracttree
    methods
        % Constructor
        function obj = mexOctree(varargin)
            
            if or((nargin < 1),(nargin > 4))
                disp('Requires 1 to 4 arguments!');
                disp('First  is the point coordinates (Mx3 matrix).');
                disp('Second is the bounding box dimensions for the points: 1x6 vector [X_min, X_max, Y_min, Y_max, Z_min, Z_max].');
                disp('Third  is the maximum number of tree levels to use in the octree.');
                disp('Fourth is the bucket size to use for the number of points to store in each leaf cell.');
                error('Check the arguments!');
            end
            % first use base constructor
            obj = obj@mexAbstracttree(varargin{1:end}); % split up the inputs
            
            % check Bounding_Box
            if ~and(size(obj.Bounding_Box,1)==1,size(obj.Bounding_Box,2)==6)
                error('Bounding box must be a 1x6 row vector.');
            end
            
            % Octree:
            obj.cppMEX = str2func('mexOctree_CPP');
            obj.dim    = 3; % space dimension is 2
            
            if (size(obj.Points,2)~=3)
                error('Points must have 3 columns (dimension = 3)!');
            end
            % get bounding box of points
            Min_X = min(obj.Points(:,1));
            Max_X = max(obj.Points(:,1));
            Min_Y = min(obj.Points(:,2));
            Max_Y = max(obj.Points(:,2));
            Min_Z = min(obj.Points(:,3));
            Max_Z = max(obj.Points(:,3));
            if (nargin >= 2) % verify user bounding box against points
                BB = [Min_X, Max_X, Min_Y, Max_Y, Min_Z, Max_Z];
                BAD_BOX = (obj.Bounding_Box(1) > BB(1)) || (obj.Bounding_Box(2) < BB(2)) ||...
                          (obj.Bounding_Box(3) > BB(3)) || (obj.Bounding_Box(4) < BB(4)) ||...
                          (obj.Bounding_Box(5) > BB(5)) || (obj.Bounding_Box(6) < BB(6));
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
                Z_Diff = Max_Z - Min_Z;
                % set bounding box coordinates to be slightly larger (default)
                obj.Bounding_Box = [Min_X - (0.001*X_Diff), Max_X + (0.001*X_Diff),...
                                    Min_Y - (0.001*Y_Diff), Max_Y + (0.001*Y_Diff),...
                                    Min_Z - (0.001*Z_Diff), Max_Z + (0.001*Z_Diff)];
            end
            
            % now create an instance of the C++ class
            % note: this will build the tree from the given points
            obj.cppHandle = obj.cppMEX('new',obj.Points,obj.Bounding_Box,obj.Max_Tree_Levels,obj.Bucket_Size);
        end
    end
end

% END %