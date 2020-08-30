function status = test_FEL_MeshTriangle_Facet_Info_1()
%test_FEL_MeshTriangle_Facet_Info_1
%
%   Test code for FELICITY class.

% Copyright (c) 05-20-2013,  Shawn W. Walker

% define simple square mesh
Vtx = [0 0; 1 0; 1 1; 0 1; 0.5 0.5]; % coordinates
Tri = [1 2 5; 2 3 5; 3 4 5; 4 1 5];  % triangle connectivity

% create a mesh object
Mesh  = MeshTriangle(Tri,Vtx,'Square');
Edges = Mesh.edges;
[Tri_Edge, Tri_Edge_Orient] = Mesh.Get_Facet_Info(Edges);

% store reference data
Edges_REF = [...
     1     2;
     1     4;
     1     5;
     2     3;
     2     5;
     3     4;
     3     5;
     4     5];
%
Tri_Edge_REF = [...
     5     3     1;
     7     5     4;
     8     7     6;
     3     8     2];
%
Tri_Edge_Orient_REF = [...
     1     0     1;
     1     0     1;
     1     0     1;
     1     0     0];
%

% check if it is correct
Edges_ERROR           = max(max(abs(Edges - Edges_REF)));
Tri_Edge_ERROR        = max(max(abs(Tri_Edge - Tri_Edge_REF)));
Tri_Edge_Orient_ERROR = max(max(abs(Tri_Edge_Orient - Tri_Edge_Orient_REF)));

status = max([Edges_ERROR,Tri_Edge_ERROR,Tri_Edge_Orient_ERROR]);

if (status==0)
    disp('Test Passed!');
else
    disp('Test Failed!');
end

end