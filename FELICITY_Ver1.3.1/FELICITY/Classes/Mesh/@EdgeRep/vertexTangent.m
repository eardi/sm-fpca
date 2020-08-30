function VT = vertexTangent(obj,VI)
%vertexTangent
%
%   This mimics the analogous MATLAB:triangulation method (vertexNormal).
%
%   Compute approximate tangent vector at vertices of space curve mesh.
%
%   VT = obj.vertexTangent(VI);
%
%   VI = Mx1 column vector of vertex indices at which to get discrete
%        tangent vector.
%
%   VT = MxD matrix, where ith row is the tangent vector at VI(i).
%        D = geometric dimension.

% Copyright (c) 06-13-2018,  Shawn W. Walker

if nargin==1
    Num_Vtx = size(obj.Points,1);
    VI = (1:1:Num_Vtx)';
end

% get edges attached to each vertex (for all vertices)
Stk_mat = obj.vertexAttachments(VI);
Stk = mat2cell(Stk_mat,ones(size(Stk_mat,1),1),2);

% compute the tangent vectors of each edge
[tau_vec, Edge_Length] = obj.edgeTangent();

DIM = size(tau_vec,2);
Sum_Weighted_Vec(DIM).VAL = []; % init
for kk = 1:DIM
    % compute the *weighted* area of each "star" around a vertex
    Sum_Weight = @(edge_indices) sum(Edge_Length(edge_indices) .* tau_vec(edge_indices,kk));
    Sum_Weighted_Vec(kk).VAL = cellfun(Sum_Weight, Stk);
end

% create the tangent vectors
VT_TEMP = [];
for kk = 1:DIM
    VT_TEMP = [VT_TEMP, Sum_Weighted_Vec(kk).VAL];
end

% normalize it!
VT = VT_TEMP; % init
VT_Length = sqrt(sum(VT.^2,2)) + 1E-15;

for kk = 1:DIM
    VT(:,kk) = VT(:,kk) ./ VT_Length;
end

end