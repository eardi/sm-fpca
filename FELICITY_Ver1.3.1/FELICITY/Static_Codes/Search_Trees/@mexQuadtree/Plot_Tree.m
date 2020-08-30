function FH = Plot_Tree(obj,Desired_Level,Plot_Points)
%Plot_Tree
%
%   This plots the tree graphically.  It plots all nodes at or above the given level.
%
%   FH = obj.Plot_Tree(Desired_Level,Plot_Points);
%
%   Desired_Level = node level to plot down to.
%   Plot_Points = true/false: true = plot points in quadtree; false = do not plot.
%
%   FH = handle to the MATLAB figure;

% Copyright (c) 01-14-2014,  Shawn W. Walker

if (nargin < 2)
    Desired_Level = 0; % default to getting *all* of the nodes
end
if (nargin < 3)
    Plot_Points = false; % default to not plotting points
end

if (Desired_Level < 0)
    error('Desired level node to plot must be >= 0!');
end
if (Desired_Level > obj.Max_Tree_Levels)
    warning('This will not plot anything from the C++ tree object!');
end
if (nargout~=1)
    error('You must return the figure handle!');
end

Tree_Data = obj.Get_Tree_Data(Desired_Level);

FH = figure;
num_nodes = size(Tree_Data,1);
hold on;
for ii = 1:num_nodes
    % extract data
    Level = Tree_Data{ii,1};
    Box   = Tree_Data{ii,2};
    Pts   = Tree_Data{ii,3};
    
    % plot the enclosing box of the node
    if (Level >= Desired_Level)
        Lines = get_lines(Box);
        plot(Lines(:,1),Lines(:,2),'m-');
    end
end

% now plot all of the points
if (Plot_Points)
    plot(obj.Points(:,1),obj.Points(:,2),'k.');
end
hold off;

end

function lines = get_lines(Box)

Min_X = Box(1);
Max_X = Box(2);
Min_Y = Box(3);
Max_Y = Box(4);

lines = [Min_X, Min_Y;
         Min_X, Max_Y;
         Max_X, Max_Y;
         Max_X, Min_Y;
         Min_X, Min_Y];
%
end