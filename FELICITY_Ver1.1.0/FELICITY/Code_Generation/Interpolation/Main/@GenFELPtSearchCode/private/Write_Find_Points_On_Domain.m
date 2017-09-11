function Write_Find_Points_On_Domain(fid,FPS,Search_Domain)
%Write_Find_Points_On_Domain
%
%   This generates a subroutine in the file: "Generic_Point_Search.cc".

% Copyright (c) 06-27-2014,  Shawn W. Walker

ENDL = '\n';
TAB = '    ';
%%%%%%%
Search_Domain_STR = ['find points in the sub-Domain: ', Search_Domain.Name];
fprintf(fid, [TAB, '// ', Search_Domain_STR, ENDL]);

CPP_PTS = FPS.Get_CPP_Point_Search_Vars(Search_Domain.Name);

% get function name
FuncName_STR = 'Find_Points';

fprintf(fid, [TAB, CPP_PTS.Search_Obj_Var, '->', FuncName_STR, '(', ');', ENDL]);
fprintf(fid, ['', ENDL]);

end