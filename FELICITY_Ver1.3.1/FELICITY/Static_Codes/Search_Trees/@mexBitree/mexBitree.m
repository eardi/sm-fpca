% FELICITY MATLAB class wrapper for a Bitree C++ class
%
%   obj  = mexBitree(Points);
%   obj  = mexBitree(Points,Bounding_Box);
%   obj  = mexBitree(Points,Bounding_Box,Max_Tree_Levels);
%   obj  = mexBitree(Points,Bounding_Box,Max_Tree_Levels,Bucket_Size);
%
%   Points          = Mx1 matrix representing the coordinates of the points to be
%                     partitioned by the bitree.
%   Bounding_Box    = bounding box dimensions of the points:
%                     1x2 vector [X_min, X_max].
%   Max_Tree_Levels = maximum number of tree levels to use in the bitree.
%   Bucket_Size     = the number of points to store in each leaf cell of the bitree.

% Copyright (c) 01-14-2014,  Shawn W. Walker
classdef mexBitree < mexAbstracttree
    methods
        % Constructor
        function obj = mexBitree(varargin)
            
            if or((nargin < 1),(nargin > 4))
                disp('Requires 1 to 4 arguments!');
                disp('First  is the point coordinates (Mx1 matrix).');
                disp('Second is the bounding box dimensions for the points: 1x2 vector [X_min, X_max].');
                disp('Third  is the maximum number of tree levels to use in the bitree.');
                disp('Fourth is the bucket size to use for the number of points to store in each leaf cell.');
                error('Check the arguments!');
            end
            % first use base constructor
            obj = obj@mexAbstracttree(varargin{1:end}); % split up the inputs
            
            % check Bounding_Box
            if ~and(size(obj.Bounding_Box,1)==1,size(obj.Bounding_Box,2)==2)
                error('Bounding box must be a 1x2 row vector.');
            end
            
            % Bitree:
            obj.cppMEX = str2func('mexBitree_CPP');
            obj.dim    = 1; % space dimension is 1
            
            if (size(obj.Points,2)~=1)
                error('Points must have 1 column (dimension = 1)!');
            end
            % get bounding box of points
            Min_X = min(obj.Points(:,1));
            Max_X = max(obj.Points(:,1));
            if (nargin >= 2) % verify user bounding box against points
                BB = [Min_X, Max_X];
                BAD_BOX = (obj.Bounding_Box(1) > BB(1)) || (obj.Bounding_Box(2) < BB(2));
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
                % set bounding box coordinates to be slightly larger (default)
                obj.Bounding_Box = [Min_X - (0.001*X_Diff), Max_X + (0.001*X_Diff)];
            end
            
            % now create an instance of the C++ class
            % note: this will build the tree from the given points
            obj.cppHandle = obj.cppMEX('new',obj.Points,obj.Bounding_Box,obj.Max_Tree_Levels,obj.Bucket_Size);
        end
    end
end

% END %