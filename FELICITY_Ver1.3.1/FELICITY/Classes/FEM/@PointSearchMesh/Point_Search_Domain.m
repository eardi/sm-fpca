function [Closest_Pts, Closest_Mesh_Cells] = Point_Search_Domain(obj,Domain_Name,Mesh,Given_Pts)
%Point_Search_Domain
%
%   This finds the closest points in the sub-domain of the mesh to the
%   given points.
%
%   [Closest_Pts, Closest_Mesh_Cells] = Point_Search_Domain(obj,Domain_Name,Mesh,Given_Pts)
%
%   Domain_Name = string representing (sub-)domain to search on.
%   Mesh        = FELICITY mesh object.
%   Given_Pts   = MxD matrix of points to search for;
%                 D is the geometric dimension of the mesh.
%
%   Closest_Pts = MxT matrix of local reference element coordinates;
%                 the rows of "Closest_Pts" corresponds to the rows of
%                 "Given_Pts". T is the topological dimension of the mesh.
%   Closest_Mesh_Cells = Mx1 column vector; rows correspond to
%                        "Closest_Pts".
%
%   Example:  Closest_Pts(i,:) are the local reference element coordinates,
%             corresponding to the mesh cell Closest_Mesh_Cells(i), of the
%             point in the mesh that is closest to Given_Pts(i,:).

% Copyright (c) 08-31-2016,  Shawn W. Walker

% verify the input mesh
obj.Verify_Mesh(Mesh);

% get the correct tree
Search_Struct = obj.Trees(Domain_Name);

% first get initial guess on where to search
NN = 1;
[Mesh_Cell_Indices, OT_dist] = Search_Struct.Tree.kNN_Search(Given_Pts,NN);

% next, do a local search
Cell_Indices = uint32(Mesh_Cell_Indices);
if min(Cell_Indices)==0
    error('A point was not found!');
end
%Cell_Indices = uint32(randi(Mesh.Num_Cell,size(GX,1),1));
%Sphere_Neighbors = uint32(Mesh.neighbors);
Point_Struct = {Cell_Indices, Given_Pts, Search_Struct.Neighbors};

% search!
SEARCH = obj.mex_Search_Func(Mesh.Points,uint32(Mesh.ConnectivityList),[],[],Point_Struct);

% get closest cell indices
CI = double(SEARCH.DATA{1});
if (min(CI) <= 0)
    disp('WARNING: At least one point was not found in the mesh!');
    %error('STOP!');
end

% get corresponding local reference element coordinates
Local_Ref_Coord = SEARCH.DATA{2};
N1 = 1 - sum(Local_Ref_Coord,2);
CHK = [N1, Local_Ref_Coord];
MIN_VAL = min(CHK(:));
MAX_VAL = max(CHK(:));
% make sure the coordinates are inside the ref element
if ~and(MIN_VAL >= -1e-15, MAX_VAL <= 1 + 1e-15)
    disp('Some local points are outside reference element!');
    error('STOP!');
end

% output the reference element coordinates
Closest_Pts = Local_Ref_Coord;
Closest_Mesh_Cells = CI;

% % get global coordinates of the closest points
% BC = Mesh.refToBary(Local_Ref_Coord);
% Closest_Pts = Mesh.baryToCart(CI, BC);

end