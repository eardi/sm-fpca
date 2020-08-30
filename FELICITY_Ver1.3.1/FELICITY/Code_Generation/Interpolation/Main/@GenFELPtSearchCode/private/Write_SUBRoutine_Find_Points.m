function status = Write_SUBRoutine_Find_Points(obj,fid,FPS)
%Write_SUBRoutine_Find_Points
%
%   This generates a subroutine in the file: "Generic_Point_Search.cc".

% Copyright (c) 06-26-2014,  Shawn W. Walker

ENDL = '\n';
%%%%%%%
fprintf(fid, ['', ENDL]);
fprintf(fid, ['', obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['', '/***************************************************************************************/', ENDL]);
fprintf(fid, ['', '/* here is the main calling routine for point searching */', ENDL]);
fprintf(fid, ['', 'void GPS::Find_Points ()', ENDL]);
fprintf(fid, ['', '{', ENDL]);

% loop through all of the distinct domains to search
Search_Domains = FPS.Get_Distinct_Domains;
NUM_Domains = length(Search_Domains);
for di = 1:NUM_Domains
    Search_Dom = Search_Domains{di};
    Write_Find_Points_On_Domain(fid,FPS,Search_Dom);
end

fprintf(fid, ['', '}', ENDL]);
fprintf(fid, ['', '/***************************************************************************************/', ENDL]);
status = fprintf(fid, ['', obj.END_Auto_Gen, ENDL]);

end