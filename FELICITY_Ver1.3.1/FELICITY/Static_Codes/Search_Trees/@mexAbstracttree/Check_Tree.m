function Valid = Check_Tree(obj)
%Check_Tree
%
%   This checks that points in the tree actually belong to their enclosing leaf cell.
%
%   Valid = obj.Check_Tree();
%
%   Valid = true/false: true = the tree is properly formed; false = it is not!

% Copyright (c) 01-15-2014,  Shawn W. Walker

Valid = true; % init

TD = obj.Get_Tree_Data();
num_nodes = size(TD,1);
for ii = 1:num_nodes
    % extract data
    %Level  = TD{ii,1};
    Box    = TD{ii,2};
    Pt_Ind = TD{ii,3};
    Coord  = obj.Points(Pt_Ind,:); % get actual coordinates
    
    if (~check_cell(Box,Coord))
        Valid = false;
        break;
    end
end

end

function valid = check_cell(Box,X)

% CHK_X = (Min_X <= X(:,1)) & (X(:,1) < Max_X);
% CHK_Y = (Min_Y <= X(:,2)) & (X(:,2) < Max_Y);
% CHK_Z = (Min_Z <= X(:,3)) & (X(:,3) < Max_Z);

valid = true; % init
for kk = 1:size(X,2)
    CHK = (Box(1 + 2*(kk-1)) <= X(:,kk)) & (X(:,kk) < Box(2 + 2*(kk-1)));
    valid = and(valid, min(CHK));
end

end