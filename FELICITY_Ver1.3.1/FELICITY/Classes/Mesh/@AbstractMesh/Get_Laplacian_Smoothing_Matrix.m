function Laplace_Smooth = Get_Laplacian_Smoothing_Matrix(obj)
%Get_Laplacian_Smoothing_Matrix
%
%   This outputs the Laplacian smoothing matrix for the mesh.
%
%   Laplace_Smooth = obj.Get_Laplacian_Smoothing_Matrix;
%
%   Laplace_Smooth = sparse matrix that can be used to "smooth" the mesh.
%
%   Example usage:
%
%   % get vertex list to smooth
%   Bdy = obj.freeBoundary;
%   Bdy_Vtx_Indices = unique(Bdy(:));
%   Interior_Vtx_Indices = setdiff((1:1:obj.Num_Vtx)',Bdy_Vtx_Indices);
%
%   Laplace_Smooth = obj.Get_Laplacian_Smoothing_Matrix;
% 
%   New_X = obj.Points; % init
%   Num_Sweeps = 5;
%   for ind = 1:Num_Sweeps
%       % apply one iteration of Laplacian smoothing
%       New_X(Interior_Vtx_Indices,:) = Laplace_Smooth(Interior_Vtx_Indices,:) * New_X;
%   end
%
%   % update mesh vertex positions
%   obj = obj.Set_Points(New_X); 

% Copyright (c) 05-09-2014,  Shawn W. Walker

% first, get the adjacency matrix
Adj_Mat = obj.Get_Adjacency_Matrix;
% symmetrize it! Note: the diagonal is all zeros.
Symm_Adj_Mat = Adj_Mat + Adj_Mat';

% get the number of (other) vertices attached to each vertex
row_sum = full(sum(Symm_Adj_Mat,2));

% multiply each row of Symm_Adj_Mat by 1 / row_sum
% (this implements the Laplacian smoothing operation)
invert_sum = 1 ./ row_sum;
DD = spdiags(invert_sum,0,size(Symm_Adj_Mat,1),size(Symm_Adj_Mat,2));
Laplace_Smooth = DD * Symm_Adj_Mat;

end