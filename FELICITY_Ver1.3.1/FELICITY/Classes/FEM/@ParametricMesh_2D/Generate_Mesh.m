function [TRI, VTX, BdyEDGE] = Generate_Mesh(obj,Num_Poly_Pts,Num_BCC_Points,Box_Dim)
%Generate_Mesh
%
%   This returns a mesh of the domain using TIGER.
%
%   FH = obj.Plot_Boundary(Num_Poly_Pts);
%
%   Num_Poly_Pts = number of points to use (approximately) in creating the
%                  boundary.
%   Box_Dim      = (optional) 1x2 array dictating box corner coordinates.

% Copyright (c) 08-09-2019,  Shawn W. Walker

[Bdy_Vtx, Chart_Marker] = Create_Polygonal_Boundary(obj,Num_Poly_Pts);
max_X = max(Bdy_Vtx(:,1));
min_X = min(Bdy_Vtx(:,1));
max_Y = max(Bdy_Vtx(:,2));
min_Y = min(Bdy_Vtx(:,2));
max_R = max([max_X, max_Y]);
min_R = min([min_X, min_Y]);

diff_X = max_X - min_X;
diff_Y = max_Y - min_Y;
max_diff = max([diff_X, diff_Y]);

if (nargin==3)
    buff0 = 0.25;
    Box_Dim = [min_R - buff0*max_diff, max_R + buff0*max_diff];
end

% create mesher object
tic
%Box_Dim = [0, 1];
%Num_BCC_Points = 31;
Use_Newton = false;
TOL = 1e-12; % tolerance to use in computing the cut points
% BCC mesh of the square
MG = Mesher2Dmex(Box_Dim,Num_BCC_Points,Use_Newton,TOL);
toc

% create "mesh" of polygonal bdy
Ind1 = (1:1:size(Bdy_Vtx,1))';
Bdy_Edge = [Ind1(1:end-1,1), Ind1(2:end,1);
            Ind1(end,1), Ind1(1,1)];
%

% define level set function
LS = Polygon_Mesh(Bdy_Vtx,Bdy_Edge);

% setup up handle to interpolation routine
Interp_Handle = @(pt) LS.Interpolate(pt);

tic
MG = MG.Get_Cut_Info(Interp_Handle);
toc
tic
[TRI, VTX] = MG.run_mex(Interp_Handle);
toc

% record which boundary points are attached to which charts...

% condense...
MT = MeshTriangle(TRI,VTX,'TEMP');
MT = MT.Remove_Unused_Vertices();
TRI = MT.ConnectivityList;
VTX = MT.Points;

% get the bdy edges
BdyEDGE = MT.freeBoundary();

end