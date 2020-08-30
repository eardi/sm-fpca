function Gen_Generic_Point_Search_h(obj,FPS)
%Gen_Generic_Point_Search_h
%
%   This generates the file: "Generic_Point_Search.h".

% Copyright (c) 01-29-2013,  Shawn W. Walker

ENDL = '\n';

% start with A part
File1 = 'Generic_Point_Search.h';
WRITE_File = fullfile(obj.Output_Dir, File1);
FEL_CopyFile(fullfile(obj.Skeleton_Dir, 'Generic_Point_Search_A.h'),WRITE_File);

% open file for writing
fid = fopen(WRITE_File, 'a');

% EXAMPLE:
%%%%%%%
% /*------------ BEGIN: Auto Generate ------------*/
% // set the number of point searches to perform
% #define NUM_PT_SEARCH    1
% 
% // In MATLAB, the output (POINTS) point data should look like:
% //            POINTS.DATA
% //                  .Name
% //
% // Here, we define the strings that makes these variable names
% #define OUT_DATA_str    "DATA"
% #define OUT_NAME_str    "Name"
% /*------------   END: Auto Generate ------------*/

% get number of domains to search on
Domain_Names = FPS.keys;
NUM_DOM   = length(Domain_Names);

%%%%%%%
% output text-lines
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['// set the number of point searches to perform', ENDL]);
fprintf(fid, ['#define NUM_PT_SEARCH    ', num2str(NUM_DOM), ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['// In MATLAB, the output (POINTS) point data should look like:', ENDL]);
fprintf(fid, ['//            POINTS.DATA', ENDL]);
fprintf(fid, ['//                  .Name', ENDL]);
fprintf(fid, ['//', ENDL]);
fprintf(fid, ['// Here, we define the strings that makes these variable names', ENDL]);
fprintf(fid, ['#define OUT_DATA_str    "DATA"', ENDL]);
fprintf(fid, ['#define OUT_NAME_str    "Name"', ENDL]);
fprintf(fid, [obj.END_Auto_Gen, ENDL]);
%%%%%%%

% write beginning of class definition
fprintf(fid, ['', ENDL]);
fprintf(fid, ['/***************************************************************************************/', ENDL]);
fprintf(fid, ['/*** C++ class ***/', ENDL]);
fprintf(fid, ['class Generic_Point_Search', ENDL]);
fprintf(fid, ['{', ENDL]);
fprintf(fid, ['public:', ENDL]);
fprintf(fid, ['    ', '//Generic_Point_Search (); // constructor', ENDL]);
fprintf(fid, ['    ', 'Generic_Point_Search (const mxArray *[]); // constructor', ENDL]);
fprintf(fid, ['    ', '~Generic_Point_Search (); // DE-structor', ENDL]);
fprintf(fid, ['', ENDL]);

% EXAMPLE:
%%%%%%%
%     basic routines
%%%%%%%
fprintf(fid, ['', ENDL]);
fprintf(fid, ['    ', 'void Setup_Data (const mxArray*[]);', ENDL]);
fprintf(fid, ['    ', 'void Find_Points ();', ENDL]);
fprintf(fid, ['    ', 'void Output_Points (mxArray*[]);', ENDL]);
fprintf(fid, ['    ', 'void Init_Output_Data (mxArray*[]);', ENDL]);
fprintf(fid, ['    ', 'void Output_Single_Point_Data (mwIndex, mxArray*, mxArray*, mxArray*);', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['', 'private:', ENDL]);
fprintf(fid, ['    ', '// these variables are defined from inputs coming from MATLAB', ENDL]);
fprintf(fid, ['', ENDL]);

fprintf(fid, ['    ', obj.BEGIN_Auto_Gen, ENDL]);
% subdomain classes
fprintf(fid, ['    ', '// classes for (sub)domain(s) and topological entities', ENDL]);
GeomFunc = FPS.GeomFuncs.values;
Num_GeomFunc = length(GeomFunc);
for ind=1:Num_GeomFunc
    Domain_CPP = GeomFunc{ind}.Domain.Determine_CPP_Info;
    fprintf(fid, ['    ', Domain_CPP.Data_Type_Name, '    ', Domain_CPP.Identifier_Name, ';', ENDL]);
end
fprintf(fid, ['', ENDL]);

% mesh geometry classes
fprintf(fid, ['    ', '// mesh geometry classes (can be higher order)', ENDL]);
for ind = 1:Num_GeomFunc
    DECLARE_str = [GeomFunc{ind}.CPP.Data_Type_Name, '   ', GeomFunc{ind}.CPP.Identifier_Name, ';'];
    fprintf(fid, ['    ', DECLARE_str, ENDL]);
end
fprintf(fid, ['', ENDL]);

% given and found point classes
fprintf(fid, ['    ', '// classes for search data and found points on subdomains', ENDL]);
for di = 1:NUM_DOM
    CPP_PTS = FPS.Get_CPP_Point_Search_Vars(Domain_Names{di});
    fprintf(fid, ['    ', CPP_PTS.Search_Data_CPP_Type,  '    ', CPP_PTS.Search_Data_Var, ';', ENDL]);
    fprintf(fid, ['    ', CPP_PTS.Found_Points_CPP_Type, '    ', CPP_PTS.Found_Points_Var, ';', ENDL]);
end
fprintf(fid, ['', ENDL]);

% point searches
fprintf(fid, ['    ', '// pointers to a search object for each domain to be searched', ENDL]);
for di = 1:NUM_DOM
    CPP_PTS = FPS.Get_CPP_Point_Search_Vars(Domain_Names{di});
    fprintf(fid, ['    ', CPP_PTS.Search_Obj_CPP_Type, '*    ', CPP_PTS.Search_Obj_Var, ';', ENDL]);
end

fprintf(fid, ['    ', obj.END_Auto_Gen, ENDL]);

% write the closing part
fprintf(fid, ['};', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['/***/', ENDL]);

% DONE!
fclose(fid);

end