function status = Write_SUBRoutine_Output_Points(obj,fid,FPS)
%Write_SUBRoutine_Output_Points
%
%   This generates a subroutine in the file: "Generic_Point_Search.cc".

% Copyright (c) 06-26-2014,  Shawn W. Walker

ENDL = '\n';
TAB = '    ';
TAB2 = [TAB, TAB];
%%%%%%%
fprintf(fid, ['', ENDL]);
fprintf(fid, ['', obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['', '/***************************************************************************************/', ENDL]);
fprintf(fid, ['', '/* this outputs all point searching data as MATLAB matrices (in cell arrays) */', ENDL]);
fprintf(fid, ['', 'void GPS::Output_Points (mxArray* plhs[])', ENDL]);
fprintf(fid, ['', '{', ENDL]);

Search_Domains = FPS.Get_Distinct_Domains;
NUM_Domains = length(Search_Domains);
for index = 1:NUM_Domains
    Dom_Name = Search_Domains{index}.Name;
    CPP_PTS = FPS.Get_CPP_Point_Search_Vars(Dom_Name);
    
    cpp_ind = num2str(index-1);
    fprintf(fid, [TAB, 'Output_Single_Point_Data(', cpp_ind, ', ', CPP_PTS.Found_Points_Var, '.Get_mxLocal_Points_Ptr()', ', ',...
                       'mxCreateString(', CPP_PTS.Found_Points_Var, '.Domain_Name)',...
                       ', plhs[0]);', ENDL]);
    fprintf(fid, ['', '', ENDL]);
end

fprintf(fid, ['', '}', ENDL]);
fprintf(fid, ['', '/***************************************************************************************/', ENDL]);
status = fprintf(fid, ['', obj.END_Auto_Gen, ENDL]);

end