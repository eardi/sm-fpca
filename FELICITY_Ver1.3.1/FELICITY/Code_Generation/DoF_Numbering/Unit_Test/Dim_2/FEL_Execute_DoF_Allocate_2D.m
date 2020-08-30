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
           1           2           3          32          18          16          33          19            17          70;
           1           4           2          22          17          14          23          16            15          71;
           4           5           2          34          23          26          35          22            27          72;
           5           3           2          33          35          40          32          34            41          73;
           4           6           5          36          27          24          37          26            25          74;
           4           7           6          28          25          20          29          24            21          75;
           7           8           6          38          29          30          39          28            31          76;
           6           8           5          46          37          39          47          36            38          77;
           3           9          10          58          44          42          59          45            43          78;
           3           5           9          48          43          41          49          42            40          79;
           5          11           9          60          49          52          61          48            53          80;
          11          10           9          59          61          66          58          60            67          81;
           5          12          11          62          53          50          63          52            51          82;
           5           8          12          54          51          47          55          50            46          83;
           8          13          12          64          55          56          65          54            57          84;
          12          13          11          68          63          65          69          62            64          85]);
%
Elem3_DoFmap_REF = uint32([...
    1     3    5   63    35    31    64   36    32    65    37   33    66   38   34    2    4    6;
    1     7    3   43    32    27    44   31    28    45    34   29    46   33   30    2    8    4;
    7     9    3   67    44    51    68   43    52    69    46   53    70   45   54    8   10    4;
    9     5    3   64    68    79    63   67    80    66    70   81    65   69   82   10    6    4;
    7    11    9   71    52    47    72   51    48    73    54   49    74   53   50    8   12   10;
    7    13   11   55    48    39    56   47    40    57    50   41    58   49   42    8   14   12;
   13    15   11   75    56    59    76   55    60    77    58   61    78   57   62   14   16   12;
   11    15    9   91    72    76    92   71    75    93    74   78    94   73   77   12   16   10;
    5    17   19  115    87    83   116   88    84   117    89   85   118   90   86    6   18   20;
    5     9   17   95    84    80    96   83    79    97    86   82    98   85   81    6   10   18;
    9    21   17  119    96   103   120   95   104   121    98  105   122   97  106   10   22   18;
   21    19   17  116   120   131   115  119   132   118   122  133   117  121  134   22   20   18;
    9    23   21  123   104    99   124  103   100   125   106  101   126  105  102   10   24   22;
    9    15   23  107   100    92   108   99    91   109   102   94   110  101   93   10   16   24;
   15    25   23  127   108   111   128  107   112   129   110  113   130  109  114   16   26   24;
   23    25   21  135   124   128   136  123   127   137   126  130   138  125  129   24   26   22]);
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