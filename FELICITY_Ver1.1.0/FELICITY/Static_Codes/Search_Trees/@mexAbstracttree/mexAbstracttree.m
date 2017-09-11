% Abstract class wrapper for a generic Search tree

% Copyright (c) 01-14-2014,  Shawn W. Walker
classdef mexAbstracttree < handle % this must be a sub-class of handle
    properties (SetAccess = protected, Hidden = true)
        cppHandle         % Handle to the C++ class instance
        cppMEX            % function handle to mex-file
        dim               % space dimension
    end
    properties (SetAccess = protected)
        Points
        Bounding_Box
        Max_Tree_Levels
        Bucket_Size
    end
    methods
        % Constructor
        function obj = mexAbstracttree(varargin)
            
            % error checking is done in sub-class
            
            obj.Points = varargin{1};
            
            if (nargin >= 2)
                obj.Bounding_Box = varargin{2};
            else
                obj.Bounding_Box = []; % init
            end
            
            if (nargin >= 3)
                obj.Max_Tree_Levels = varargin{3};
                if (obj.Max_Tree_Levels < 2)
                    error('Max_Tree_Levels must be >= 2!');
                end
                if (obj.Max_Tree_Levels > 32)
                    error('Max_Tree_Levels must be <= 32!');
                end
            else
                obj.Max_Tree_Levels = 32; % default
            end
            
            if (nargin >= 4)
                obj.Bucket_Size = varargin{4};
                if (obj.Bucket_Size < 1)
                    error('Bucket_Size must be an integer > 0!');
                end
            else
                obj.Bucket_Size = 20; % default
            end
            
            % init
            obj.cppHandle = [];
            obj.cppMEX    = [];
            obj.dim       = 0;
        end
        % Destructor - destroy the C++ class instance
        function delete(obj)
            %delete
            %   Destroy the tree (free its memory).
            obj.cppMEX('delete', obj.cppHandle);
        end
        % Print_Tree - display the quadtree partition as ASCII text
        function Print_Tree(obj)
            %Print_Tree
            %   print the tree info to the MATLAB display as ASCII text.
            obj.cppMEX('print_tree', obj.cppHandle);
        end
    end
    methods (Abstract)
        FH = Plot_Tree(obj,Desired_Level,Plot_Points); % graphical plot
    end
end

% END %