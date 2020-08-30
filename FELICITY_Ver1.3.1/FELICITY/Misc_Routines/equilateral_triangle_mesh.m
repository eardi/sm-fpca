function [T,V] = equilateral_triangle_mesh(nx,num_rows,side_length)
%equilateral_triangle_mesh
%
%   Generates a 2-D equilateral triangle tiling in the plane.
%   Note: one edge of every triangle is parallel to the x-axis.
%
%   [T,V] = equilateral_triangle_mesh(nx,num_rows,side_length);
%
%   Input:     
%       nx = number of points along x (must be > 1).
%       num_rows = number of rows of triangles along y (must be positive).
%       side_length = (optional) specifies side length of triangles
%                     (must be positive).  Note: this is also the spacing
%                     of the points along the x-direction.
%
%   Output:
%       T = triangle connectivity list of indices into V.
%       V = list of vertex coordinates in 2D.
%
%   Example:
%     [T,V] = equilateral_triangle_mesh(4,2,0.5);
%     trimesh(T,V(:,1),V(:,2));

% Copyright (c) 01-18-2016,  Shawn W. Walker

if (nargin==2)
    side_length = 1; % default
else
    if (side_length <=0)
        error('side_length must be positive!');
    end
end

if ~and( nx > 1 , num_rows > 0 )
    error('Must have nx > 1 and num_rows > 0!');
end
% define number of "points" along y.
ny = num_rows+1;

% define vertex index matrix, and coordinate matrices
% note: column j is the jth line of points
v_ind_mat = zeros(nx,ny);
x_coord = zeros(nx,ny);
y_coord = zeros(nx,ny);

% define first line of points
x_coord(:,1) = side_length * (0:1:(nx-1))';
x_space = x_coord(2,1) - x_coord(1,1);
y_coord(:,1) = 0*x_coord(:,1) + 0;
v_ind_mat(:,1) = (1:1:nx)';

% define next line of points shifted up one layer
x_coord(:,2) = x_coord(:,1) - (x_space/2);
y_space = sqrt(3)/2 * x_space;
%y_coord(:,2) = 0*x_coord(:,2) + y_space;

% determine if even number of points
odd_pts = ~(round(ny/2)==(ny/2));

% fill in the rest of x-coord
if odd_pts
    % note: this means num_rows is even and positive
    Num_Hex_Layer = num_rows/2;
    x1_repmat = repmat(x_coord(:,1),1,Num_Hex_Layer);
    x2_repmat = repmat(x_coord(:,2),1,Num_Hex_Layer);
    x_coord(:,3:2:end)   = x1_repmat;
    x_coord(:,2:2:end-1) = x2_repmat;
else
    if (num_rows >=3)
        % note: this means num_rows is odd and >=3
        Num_Hex_Layer = (num_rows-1)/2;
        x1_repmat = repmat(x_coord(:,1),1,Num_Hex_Layer);
        x2_repmat = repmat(x_coord(:,2),1,Num_Hex_Layer+1);
        x_coord(:,3:2:end-1) = x1_repmat;
        x_coord(:,2:2:end)   = x2_repmat;
    end
    % don't need to do anything for num_rows==1
end

% fill in y_coord and indices
First_Col_Ind = v_ind_mat(:,1);
for jj = 2:ny
    y_coord(:,jj) = (jj-1)*y_space;
    v_ind_mat(:,jj) = First_Col_Ind + v_ind_mat(end,jj-1);
end

% collect vertex coordinates
V = [x_coord(:), y_coord(:)];

% define the triangles
if (num_rows==1)
    v1 = v_ind_mat(:,1);
    v2 = v_ind_mat(:,2);
    T = [v1(1:end-1,1) v2(2:end,1) v2(1:end-1,1);
         v1(1:end-1,1) v1(2:end,1) v2(2:end,1)];
elseif (num_rows >= 2)
    L1 = 2*(size(v_ind_mat,1)-1);
    T = zeros(num_rows*L1,3);
    for ii = 1:2:num_rows-1
        v1 = v_ind_mat(:,ii);
        v2 = v_ind_mat(:,ii+1);
        T((ii-1)*L1 + 1:ii*L1,:) = [
             v1(1:end-1,1) v2(2:end,1) v2(1:end-1,1);
             v1(1:end-1,1) v1(2:end,1) v2(2:end,1)];
        v1 = v_ind_mat(:,ii+1);
        v2 = v_ind_mat(:,ii+2);
        T(ii*L1 + 1:(ii+1)*L1,:) = [
             v1(1:end-1,1) v1(2:end,1) v2(1:end-1,1);
             v1(2:end,1)   v2(2:end,1) v2(1:end-1,1)];
    end
    if (ii < num_rows-1)
        v1 = v_ind_mat(:,end-1);
        v2 = v_ind_mat(:,end);
        T(end-L1 + 1:end,:) = [
             v1(1:end-1,1) v2(2:end,1) v2(1:end-1,1);
             v1(1:end-1,1) v1(2:end,1) v2(2:end,1)];
    end
end

end