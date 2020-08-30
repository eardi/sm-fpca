function status = test_FEL_ptsearch_mesh_T2_G2()
%test_FEL_ptsearch_mesh_T2_G2
%
%   Test code for FELICITY class.

% Copyright (c) 08-31-2016,  Shawn W. Walker

Main_Dir = fileparts(mfilename('fullpath'));

% load up the standard test mesh
[Vtx, Tri] = Standard_Triangle_Mesh_Test_Data();

% create a mesh object
Mesh = MeshTriangle(Tri,Vtx,'Omega');
% define a 1D subdomain of the square mesh
Bdy_Edge = Mesh.freeBoundary;
Mesh = Mesh.Append_Subdomain('1D','Boundary',Bdy_Edge);

% declare the definition file
PtSearch_Defn = @FEL_PtSearch_Mesh_T2_G2;

% create the object
PSM = PointSearchMesh(PtSearch_Defn,{},Main_Dir,Mesh);

% compile the internal point search code
Path_To_Mex = PSM.Compile_MEX;

% setup the search tree
%BB = Mesh.Bounding_Box();
%BB = BB + 0.1*[-1, 1, -1, 1, -1, 1];
BB = [-1 3 -1 3];
PSM = PSM.Setup_Search_Tree(Mesh,BB);

% search the given points
Given_Pts = rand(10,2) + 0.5;
[Closest_Pts, Closest_Mesh_Cells] = PSM.Point_Search_Domain('Omega',Mesh,Given_Pts);
% get global coordinates of the closest points
GX = Mesh.referenceToCartesian(Closest_Mesh_Cells,Closest_Pts);

% plot the mesh
figure;
Mesh.Plot;
AX = [0 2 0 2];
axis(AX);
hold on;
plot(Given_Pts(:,1), Given_Pts(:,2),'rs');
plot(GX(:,1), GX(:,2),'k.');
hold off;
axis equal;
axis(AX);
title('Triangle Mesh (red squares are "given" points)');
xlabel('black dots are "found" points.');

% run regression test
status = 0;
PT_ERR = abs(Given_Pts - GX);
PT_ERR = max(PT_ERR(:));
if PT_ERR > 1e-15
    PT_ERR
    disp('(Given_Pts): error in finding points is too large!.');
    disp('See "test_ptsearch_mesh_T2_G2".');
    status = 1;
end

% % delete mex file...
% delete([Path_To_Mex, '.*']);

end