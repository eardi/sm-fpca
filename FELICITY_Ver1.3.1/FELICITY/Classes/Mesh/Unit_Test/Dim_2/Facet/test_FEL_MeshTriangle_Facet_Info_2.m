function status = test_FEL_MeshTriangle_Facet_Info_2()
%test_FEL_MeshTriangle_Facet_Info_2
%
%   Test code for FELICITY class.

% Copyright (c) 05-20-2013,  Shawn W. Walker

% load reference square mesh
[Vtx, Tri] = Standard_Triangle_Mesh_Test_Data();

% create a mesh object
Mesh  = MeshTriangle(Tri,Vtx,'Square');
Edges = Mesh.edges;
[Tri_Edge, Tri_Edge_Orient] = Mesh.Get_Facet_Info(Edges);

% store reference data
Edges_REF = [...
     1     2;
     1     4;
     1     6;
     2     3;
     2     4;
     2     5;
     2     7;
     3     5;
     3     8;
     4     6;
     4     7;
     5     7;
     5     8;
     6     7;
     6     9;
     6    11;
     7     8;
     7     9;
     7    10;
     7    12;
     8    10;
     8    13;
     9    11;
     9    12;
    10    12;
    10    13;
    11    12;
    12    13];
%
Tri_Edge_REF = [...
    10     3     2;
     5     2     1;
    11     5     7;
    10    11    14;
    12     7     6;
     8     6     4;
    13     8     9;
    17    12    13;
    23    16    15;
    18    15    14;
    24    18    20;
    23    24    27;
    25    20    19;
    21    19    17;
    26    21    22;
    28    25    26];
%
Tri_Edge_Orient_REF = [...
     1     0     1;
     1     0     1;
     0     0     1;
     0     1     0;
     1     0     1;
     1     0     1;
     0     0     1;
     0     0     1;
     1     0     1;
     1     0     1;
     0     0     1;
     0     1     0;
     1     0     1;
     1     0     1;
     0     0     1;
     0     0     1];
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