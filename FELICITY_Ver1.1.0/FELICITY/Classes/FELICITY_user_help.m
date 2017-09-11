function FELICITY_user_help()
%FELICITY_user_help
%
%   Prints the classes and various files that are of interest to the end-user
%   and some other help information.

% Copyright (c) 03-06-2013,  Shawn W. Walker

CL.Mesh = {'MeshInterval'; 'MeshTriangle'; 'MeshTetrahedron'};

CL.Elem_Defn =...
    {'brezzi_douglas_marini_deg1_dim2.m';
     'constant_one.m';
     'lagrange_deg0_dim1.m';
     'lagrange_deg0_dim2.m';
     'lagrange_deg0_dim3.m';
     'lagrange_deg1_dim1.m';
     'lagrange_deg1_dim2.m';
     'lagrange_deg1_dim3.m';
     'lagrange_deg2_dim1.m';
     'lagrange_deg2_dim2.m';
     'raviart_thomas_deg0_dim2.m'};
%

CL.FEM  = {'FELOutputElemInfo'; 'ReferenceFiniteElement'; 'FiniteElementSpace'; 'FEMatrixAccessor'};

CL.ManageSim  = {'FEL_SaveLoad'; 'FEL_Sim_Template'; 'FEL_Visualize'};

CL.Code_Gen.General   = {'FELInterface'};

CL.Code_Gen.Mat_Assem =...
   {'Bilinear';
    'Coef';
    'Domain';
    'Element';
    'GeoElement';
    'GeoFunc';
    'Integral';
    'Linear';
    'Matrices';
    'Real';
    'Test';
    'Trial'};
%

CL.Code_Gen.Interpolation =...
   {'Interpolate';
    'Interpolations'};
%

CL.Code_Gen.PointSearch =...
   {'PointSearches'};
%

CL.Static_Code.Meshing =...
   {'Mesher2Dmex'; 'Mesher3Dmex'; 'FEL_Mesh_Smooth'};
%
CL.Static_Code.Search_Trees =...
   {'mexBitree'; 'mexQuadtree'; 'mexOctree'};
%
CL.Static_Code.Misc =...
   {'SolveEikonal2Dmex'};
%

% display to the screen
disp('---------------------------------------------------------');
disp('FELICITY Classes and M-Files of interest to the end-user:');
disp('---------------------------------------------------------');
disp(' ');

disp('Classes used for storing and manipulating meshes:');
disp(' ');
disp(CL.Mesh);

disp('List of current reference finite elements defined in FELICITY:');
disp(' ');
disp(CL.Elem_Defn);

disp('Classes used for storing and manipulating finite element spaces,');
disp('        and managing Degrees-of-Freedom (DoF''s):');
disp(' ');
disp(CL.FEM);

disp('Classes used for managing simulation data:');
disp(' ');
disp(CL.ManageSim);

disp('Classes used for interfacing to FELICITY''s code generation:');
disp(' ');
disp(CL.Code_Gen.General);

disp('Classes used in FELICITY''s domain-specific-language (DSL) for ');
disp('        finite element matrix assembly:');
disp(' ');
disp(CL.Code_Gen.Mat_Assem);

disp('Classes used in FELICITY''s DSL for finite element interpolation:');
disp(' ');
disp(CL.Code_Gen.Interpolation);

disp('Classes used in FELICITY''s DSL for point searching:');
disp(' ');
disp(CL.Code_Gen.PointSearch);

disp('Classes for mesh generation and mesh smoothing:');
disp(' ');
disp(CL.Static_Code.Meshing);

disp('Classes for search trees:');
disp(' ');
disp(CL.Static_Code.Search_Trees);

disp('Miscellaneous classes:');
disp(' ');
disp(CL.Static_Code.Misc);

disp(' ');
disp('Help usage:');
disp('---------------------------------------------------------');
disp('Simply type ''help XXX'', where XXX is one of the class');
disp('or file names listed above to get information on how to');
disp('create an object of that class or how to call that');
disp('function.');
disp(' ');
disp('You can list the methods of a class by calling the');
disp('built-in MATLAB function ''methods''.  For example,');
disp('      methods(''MeshTriangle'')');
disp('lists the methods of the class MeshTriangle.');
disp(' ');
disp('You can get help information for a method of a class');
disp('by typing ''help XXX.mmm'', where XXX is the class');
disp('and mmm is the method you want.');
%disp(' ');

disp('---------------------------------------------------------');
disp(' ');

end