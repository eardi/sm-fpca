function status = FEL_Execute_DoF_Allocate_3D(mexName)
%FEL_Execute_DoF_Allocate_3D
%
%   Test code for FELICITY class.

% Copyright (c) 05-30-2013,  Shawn W. Walker

% load up the 'standard' triangulation
[Vtx, Tet] = Standard_Tet_Mesh_Test_Data();
% rearrange to better test code!
Tet = [2     6     5     1;
       3     6     5     2;
       5     4     6     3;
       6     1     4     5];
%

% allocate DoFs
tic
[Elem1_DoFmap, Elem2_DoFmap, Elem3_DoFmap, Elem4_DoFmap, Elem5_DoFmap] = feval(str2func(mexName),uint32(Tet));
toc

% Elem1_DoFmap
%
% Elem2_DoFmap
% 
% Elem3_DoFmap
% 
% Elem4_DoFmap
%
% Elem5_DoFmap

% define reference DoFmap(s)
Elem1_DoFmap_REF = uint32([...
           1           2           3           4;
           5           2           3           1;
           3           6           2           5;
           2           4           6           3]);
%
% Elem2_DoFmap_REF_OLD = uint32([...
%           13          14          11          12           2           1          26          25           6           5           7          8;
%           19          20          17          18          10           9          26          25          12          11          13         14;
%           22          21          25          26          18          17          23          24          20          19          15         16;
%            8           7          24          23          26          25           3           4          21          22           6          5]);
% %

Elem2_DoFmap_REF = uint32([...
          13          14          11          12           1           2          25          26           5           6           7           8;
          19          20          17          18           9          10          25          26          12          11          13          14;
          21          22          26          25          18          17          23          24          20          19          15          16;
           8           7          24          23          25          26           3           4          22          21           5           6]);
%

Elem3_DoFmap_REF = uint32([...
          25          26          27          28          29          30           1           2           3           4           5           6           7           8           9          10          11          12          43          44          45          46          47          48          73;
          48          47          46          45          44          43          31          32          33          34          35          36          37          38          39          40          41          42          61          62          63          64          65          66          74;
          55          56          57          58          59          60          64          63          62          61          66          65          49          50          51          52          53          54          67          68          69          70          71          72          75;
          13          14          15          16          17          18          70          69          68          67          72          71          26          25          30          29          28          27          19          20          21          22          23          24          76]);
%
Elem4_DoFmap_REF = uint32([...
          17          18          19           1           2           3           5           6           7          29          30          31          20           4           8          32;
          31          30          29          21          22          23          25          26          27          41          42          43          32          24          28          44;
          37          38          39          42          41          43          33          34          35          45          46          47          40          44          36          48;
           9          10          11          46          45          47          17          19          18          13          14          15          12          48          20          16]);
%
Elem5_DoFmap_REF = uint32([...
           1           2           3           4           5;
           6           7           8           9          10;
          11          12          13          14          15;
          16          17          18          19          20]);
%

% check if it is correct
Elem1_DoF_ERROR = max(abs(Elem1_DoFmap(:) - Elem1_DoFmap_REF(:)));
Elem2_DoF_ERROR = max(abs(Elem2_DoFmap(:) - Elem2_DoFmap_REF(:)));
Elem3_DoF_ERROR = max(abs(Elem3_DoFmap(:) - Elem3_DoFmap_REF(:)));
Elem4_DoF_ERROR = max(abs(Elem4_DoFmap(:) - Elem4_DoFmap_REF(:)));
Elem5_DoF_ERROR = max(abs(Elem5_DoFmap(:) - Elem5_DoFmap_REF(:)));
if ~(Elem1_DoF_ERROR==0)
    disp('Test Failed for Elem1_DoFmap.');
    status = 1;
elseif ~(Elem2_DoF_ERROR==0)
    
    Elem2_DoFmap
    
    disp('Test Failed for Elem2_DoFmap.');
    status = 1;
elseif ~(Elem3_DoF_ERROR==0)
    disp('Test Failed for Elem3_DoFmap.');
    status = 1;
elseif ~(Elem4_DoF_ERROR==0)
    disp('Test Failed for Elem4_DoFmap.');
    status = 1;
elseif ~(Elem5_DoF_ERROR==0)
    disp('Test Failed for Elem5_DoFmap.');
    status = 1;
else
    status = 0;
end

end