function status = FEL_Execute_DoF_Allocate_2D(mexName)
%FEL_Execute_DoF_Allocate_2D
%
%   Test code for FELICITY class.

% Copyright (c) 01-01-2011,  Shawn W. Walker

% load up the 'standard' triangulation
[Vtx, Tri] = Standard_Triangle_Mesh_Test_Data();
% for ind = 1:0
%     Marked_Tri = (1:1:size(Tri,1))';
%     [Vtx, Tri] = Refine_Entire_Mesh(Vtx,Tri,[],Marked_Tri);
% end

% allocate DoFs
tic
[Elem1_DoFmap, Elem2_DoFmap, Elem3_DoFmap, Elem4_DoFmap] = feval(str2func(mexName),uint32(Tri));
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
           1           2           3;
           1           4           2;
           4           5           2;
           5           3           2;
           4           6           5;
           4           7           6;
           7           8           6;
           6           8           5;
           3           9          10;
           3           5           9;
           5          11           9;
          11          10           9;
           5          12          11;
           5           8          12;
           8          13          12;
          12          13          11]);
%
Elem2_DoFmap_REF = uint32([...
           1           2           3          32          19          16          33          18          17          70;
           1           4           2          22          17          14          23          16          15          71;
           4           5           2          35          23          26          34          22          27          72;
           5           3           2          33          34          41          32          35          40          73;
           4           6           5          36          27          24          37          26          25          74;
           4           7           6          28          25          20          29          24          21          75;
           7           8           6          39          29          30          38          28          31          76;
           6           8           5          47          37          38          46          36          39          77;
           3           9          10          58          45          42          59          44          43          78;
           3           5           9          48          43          40          49          42          41          79;
           5          11           9          61          49          52          60          48          53          80;
          11          10           9          59          60          67          58          61          66          81;
           5          12          11          62          53          50          63          52          51          82;
           5           8          12          54          51          46          55          50          47          83;
           8          13          12          65          55          56          64          54          57          84;
          12          13          11          69          63          64          68          62          65          85]);
%
Elem3_DoFmap_REF = uint32([...
       1    3    5    63    36    31    64    35    32    65    38    33    66    37    34    2    4    6;
       1    7    3    43    32    27    44    31    28    45    34    29    46    33    30    2    8    4;
       7    9    3    68    44    51    67    43    52    70    46    53    69    45    54    8   10    4;
       9    5    3    64    67    80    63    68    79    66    69    82    65    70    81   10    6    4;
       7   11    9    71    52    47    72    51    48    73    54    49    74    53    50    8   12   10;
       7   13   11    55    48    39    56    47    40    57    50    41    58    49    42    8   14   12;
      13   15   11    76    56    59    75    55    60    78    58    61    77    57    62   14   16   12;
      11   15    9    92    72    75    91    71    76    94    74    77    93    73    78   12   16   10;
       5   17   19   115    88    83   116    87    84   117    90    85   118    89    86    6   18   20;
       5    9   17    95    84    79    96    83    80    97    86    81    98    85    82    6   10   18;
       9   21   17   120    96   103   119    95   104   122    98   105   121    97   106   10   22   18;
      21   19   17   116   119   132   115   120   131   118   121   134   117   122   133   22   20   18;
       9   23   21   123   104    99   124   103   100   125   106   101   126   105   102   10   24   22;
       9   15   23   107   100    91   108    99    92   109   102    93   110   101    94   10   16   24;
      15   25   23   128   108   111   127   107   112   130   110   113   129   109   114   16   26   24;
      23   25   21   136   124   127   135   123   128   138   126   129   137   125   130   24   26   22]);
%
Elem4_DoFmap_REF = uint32([...
           1           2           3           4;
           5           6           7           8;
           9          10          11          12;
          13          14          15          16;
          17          18          19          20;
          21          22          23          24;
          25          26          27          28;
          29          30          31          32;
          33          34          35          36;
          37          38          39          40;
          41          42          43          44;
          45          46          47          48;
          49          50          51          52;
          53          54          55          56;
          57          58          59          60;
          61          62          63          64]);
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