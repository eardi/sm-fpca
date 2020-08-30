function status = test_FEL_ptsearch_mesh_T2_G3()
%test_FEL_ptsearch_mesh_T2_G3
%
%   Test code for FELICITY class.

% Copyright (c) 08-31-2016,  Shawn W. Walker

Main_Dir = fileparts(mfilename('fullpath'));

% load up the standard test mesh
[Vtx, Tri] = Standard_Triangle_Mesh_Test_Data();

% make a surface mesh
Z = 1.0*sin(Vtx(:,1)).*cos(Vtx(:,2));
Vtx = [Vtx, Z];

% create a mesh object
Mesh = MeshTriangle(Tri,Vtx,'Gamma');
% define a 1D subdomain of the square mesh
Bdy_Edge = Mesh.freeBoundary;
Mesh = Mesh.Append_Subdomain('1D','Boundary',Bdy_Edge);

% declare the definition file
PtSearch_Defn = @FEL_PtSearch_Mesh_T2_G3;

% create the object
PSM = PointSearchMesh(PtSearch_Defn,{},Main_Dir,Mesh);

% compile the internal point search code
Path_To_Mex = PSM.Compile_MEX;

% setup the search tree
%BB = Mesh.Bounding_Box();
%BB = BB + 0.1*[-1, 1, -1, 1, -1, 1];
BB = [-1 3 -1 3 -2 2];
PSM = PSM.Setup_Search_Tree(Mesh,BB);

% search the given points
% Given_Pts = [rand(10,1) + 0.5, rand(10,1) + 0.5, rand(10,1) + 0.0];
% Given_Pts
Given_Pts = [...
     1.353031117721894e+00     9.172670690843695e-01     7.802520683211379e-01;
     1.122055131485066e+00     5.496544303257421e-01     3.897388369612534e-01;
     8.509523808922709e-01     1.402716109915281e+00     2.416912859138327e-01;
     1.013249539867053e+00     1.444787189721646e+00     4.039121455881147e-01;
     9.018080337519417e-01     9.908640924680799e-01     9.645452516838859e-02;
     5.759666916908419e-01     9.892526384000189e-01     1.319732926063351e-01;
     7.399161535536580e-01     8.377194098213772e-01     9.420505907754851e-01;
     6.233189348351655e-01     1.400053846417662e+00     9.561345402298023e-01;
     6.839077882824167e-01     8.692467811202150e-01     5.752085950784656e-01;
     7.399525256649028e-01     6.112027552937874e-01     5.977954294715582e-02];
[Closest_Pts, Closest_Mesh_Cells] = PSM.Point_Search_Domain('Gamma',Mesh,Given_Pts);
% get global coordinates of the closest points
GX = Mesh.referenceToCartesian(Closest_Mesh_Cells,Closest_Pts);

%Closest_Pts
Closest_Pts_REF = [...
     1.556689012240796e-01     4.386696232326562e-01;
     4.660455896282212e-02     6.103726294948590e-01;
     1.993443486034051e-01     2.929120474485178e-01;
     4.013273046869414e-02     2.750120210760174e-01;
     7.142243184672332e-01     1.625912989347469e-01;
     5.035516225627811e-01     5.496443208820071e-02;
     6.047831499951847e-01     1.562206845599138e-01;
                         0     2.619937381533639e-01;
     5.276420942813338e-02     3.833950822264776e-01;
     1.361822038536334e-01     5.340172541065884e-01];
%

% plot the mesh
figure;
Mesh.Plot;
AX = [0 2 0 2 -0.5 1.5];
axis(AX);
hold on;
plot3(Given_Pts(:,1), Given_Pts(:,2), Given_Pts(:,3),'rs');
plot3(GX(:,1),GX(:,2),GX(:,3),'k.');
plot3([Given_Pts(:,1), GX(:,1)]',[Given_Pts(:,2), GX(:,2)]',[Given_Pts(:,3), GX(:,3)]','r-');
hold off;
axis equal;
axis(AX);
title('Triangle Mesh (red squares are "given" points)');
xlabel('black dots are "found" points.');
view(-120,25);

% run regression test
status = 0;
PT_ERR = abs(Closest_Pts - Closest_Pts_REF);
PT_ERR = max(PT_ERR(:));
if PT_ERR > 1e-15
    PT_ERR
    disp('(Given_Pts): error in finding points is too large!.');
    disp('See "test_ptsearch_mesh_T2_G3".');
    status = 1;
end

% % delete mex file...
% delete([Path_To_Mex, '.*']);

end