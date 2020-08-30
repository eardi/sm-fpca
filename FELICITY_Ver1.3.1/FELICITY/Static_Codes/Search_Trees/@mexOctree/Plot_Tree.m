function FH = Plot_Tree(obj,Desired_Level,Plot_Points)
%Plot_Tree
%
%   This plots the tree graphically.  It plots all nodes at or above the given level.
%
%   FH = obj.Plot_Tree(Desired_Level,Plot_Points);
%
%   Desired_Level = node level to plot down to.
%   Plot_Points = true/false: true = plot points in octree; false = do not plot.
%
%   FH = handle to the MATLAB figure;

% Copyright (c) 01-15-2014,  Shawn W. Walker

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
        plot3(Lines{1},Lines{2},Lines{3},'b-');
    end
end

% now plot all of the points
if (Plot_Points)
    plot3(obj.Points(:,1),obj.Points(:,2),obj.Points(:,3),'k.');
end
hold off;

end

function lines = get_lines(Box)

Min_X = Box(1);
Max_X = Box(2);
Min_Y = Box(3);
Max_Y = Box(4);
Min_Z = Box(5);
Max_Z = Box(6);

lines = cell(3,1);
lines{1} = [Min_X, Min_X, Min_X, Max_X, Min_X, Min_X, Min_X, Max_X, Min_X, Max_X, Min_X, Max_X;
            Max_X, Min_X, Max_X, Max_X, Max_X, Min_X, Max_X, Max_X, Min_X, Max_X, Min_X, Max_X];
lines{2} = [Min_Y, Min_Y, Max_Y, Min_Y, Min_Y, Min_Y, Max_Y, Min_Y, Min_Y, Min_Y, Max_Y, Max_Y;
            Min_Y, Max_Y, Max_Y, Max_Y, Min_Y, Max_Y, Max_Y, Max_Y, Min_Y, Min_Y, Max_Y, Max_Y]; 
lines{3} = [Min_Z, Min_Z, Min_Z, Min_Z, Max_Z, Max_Z, Max_Z, Max_Z, Min_Z, Min_Z, Min_Z, Min_Z;
            Min_Z, Min_Z, Min_Z, Min_Z, Max_Z, Max_Z, Max_Z, Max_Z, Max_Z, Max_Z, Max_Z, Max_Z];
%

end