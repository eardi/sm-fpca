function status = Write_SUBRoutine_Output_Interpolations(obj,fid,FI)
%Write_SUBRoutine_Output_Interpolations
%
%   This generates a subroutine in the file: "Generic_FEM_Interpolation.cc".

% Copyright (c) 02-02-2013,  Shawn W. Walker

ENDL = '\n';
TAB = '    ';
TAB2 = [TAB, TAB];
%%%%%%%
fprintf(fid, ['', ENDL]);
fprintf(fid, ['', obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['', '/***************************************************************************************/', ENDL]);
fprintf(fid, ['', '/* this outputs all FEM interpolations as MATLAB vectors (in cell arrays) */', ENDL]);
fprintf(fid, ['', 'void GFI::Output_Interpolations (mxArray* plhs[])', ENDL]);
fprintf(fid, ['', '{', ENDL]);

Interp_Names = FI.keys;
NUM_INTERP = length(Interp_Names);
for index = 1:NUM_INTERP
    INT_CPP = FI.Get_Interpolation_CPP_Info(Interp_Names{index});
    
    cpp_ind = num2str(index-1);
    fprintf(fid, [TAB, 'Output_Single_Interpolation(', cpp_ind, ', ', INT_CPP.Var_Name, '->mxInterp_Data', ', ',...
                       'mxCreateString(', INT_CPP.Var_Name, '->Name)',...
                       ', plhs[0]);', ENDL]);
    fprintf(fid, [TAB, 'delete(', INT_CPP.Var_Name, ');', ENDL]);
    fprintf(fid, ['', '', ENDL]);
end

fprintf(fid, ['', '}', ENDL]);
fprintf(fid, ['', '/***************************************************************************************/', ENDL]);
status = fprintf(fid, ['', obj.END_Auto_Gen, ENDL]);

end