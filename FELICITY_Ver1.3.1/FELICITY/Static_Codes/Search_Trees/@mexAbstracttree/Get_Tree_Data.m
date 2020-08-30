function Tree_Data = Get_Tree_Data(obj,Desired_Level)
%Get_Tree_Data
%
%   This extracts data about the tree from the C++ class instance, such as the
%   enclosing cell (node) dimensions, and points contained there in.
%
%   Tree_Data = obj.Get_Tree_Data(Desired_Level);
%
%   Desired_Level = lowest level of cell (node) to extract.
%
%   Tree_Data = Mx3 MATLAB cell array, where M is the number of nodes of
%               level >= Desired_Level.  Note: root node has highest level.
%               Column 1: level of cell.
%               Column 2: vector of cell dimensions: [Min_X, Max_X, Min_Y, Max_Y, ...],
%                         of length 2*d, where d is the space dimension.
%               Column 3: indices of points (indexing into obj.Points) that are contained
%                         in the cell.

% Copyright (c) 01-11-2014,  Shawn W. Walker

if (nargin==1)
    Desired_Level = 0; % default to getting *all* of the nodes
end
if (Desired_Level < 0)
    error('Desired level node to plot must be >= 0!');
end
if (Desired_Level > obj.Max_Tree_Levels)
    warning('This will not extract anything from the C++ tree object!');
end
if (nargout~=1)
    error('You must return the tree data!');
end

Tree_Data = obj.cppMEX('tree_data', obj.cppHandle, Desired_Level);

end