function status = FEL_Execute_DoF_Allocate_1D(mexName)
%FEL_Execute_DoF_Allocate_1D
%
%   Test code for FELICITY class.

% Copyright (c) 01-01-2011,  Shawn W. Walker

% load up the 'standard' triangulation
[Vtx, Edge] = Standard_Edge_Mesh_Test_Data();

% allocate DoFs
%com_string = [mexName,'(uint32(Edge));'];
tic
[Elem1_DoFmap, Elem2_DoFmap, Elem3_DoFmap, Elem4_DoFmap] = feval(str2func(mexName),uint32(Edge));
toc

% Elem1_DoFmap
% 
% Elem2_DoFmap
% 
% Elem3_DoFmap
% 
% Elem4_DoFmap

% define reference DoFmap(s)
Elem1_DoFmap_REF = uint32([...
           1           2;
           2           3;
           3           4;
           4           5;
           5           6;
           6           7;
           7           8;
           8           9;
           9          10]);
%
Elem2_DoFmap_REF = uint32([...
           1           2          11          12          13;
           2           3          14          15          16;
           3           4          17          18          19;
           4           5          20          21          22;
           5           6          23          24          25;
           6           7          26          27          28;
           7           8          29          30          31;
           8           9          32          33          34;
           9          10          35          36          37]);
%
Elem3_DoFmap_REF = uint32([...
           1           3          21          22           2           4;
           3           5          23          24           4           6;
           5           7          25          26           6           8;
           7           9          27          28           8          10;
           9          11          29          30          10          12;
          11          13          31          32          12          14;
          13          15          33          34          14          16;
          15          17          35          36          16          18;
          17          19          37          38          18          20]);
%
Elem4_DoFmap_REF = uint32([...
           1           2           3;
           4           5           6;
           7           8           9;
          10          11          12;
          13          14          15;
          16          17          18;
          19          20          21;
          22          23          24;
          25          26          27]);
%
% check if it is correct
Elem1_DoF_ERROR = max(abs(Elem1_DoFmap(:) - Elem1_DoFmap_REF(:)));
Elem2_DoF_ERROR = max(abs(Elem2_DoFmap(:) - Elem2_DoFmap_REF(:)));
Elem3_DoF_ERROR = max(abs(Elem3_DoFmap(:) - Elem3_DoFmap_REF(:)));
Elem4_DoF_ERROR = max(abs(Elem4_DoFmap(:) - Elem4_DoFmap_REF(:)));
if ~(Elem1_DoF_ERROR==0)
    disp('Test Failed for Elem1_DoFmap.');
    status = 1;
elseif ~(Elem2_DoF_ERROR==0)
    disp('Test Failed for Elem2_DoFmap.');
    status = 1;
elseif ~(Elem3_DoF_ERROR==0)
    disp('Test Failed for Elem3_DoFmap.');
    status = 1;
elseif ~(Elem4_DoF_ERROR==0)
    disp('Test Failed for Elem4_DoFmap.');
    status = 1;
else
    status = 0;
end

end