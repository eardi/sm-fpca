function status = Write_SUBRoutine_Output_Matrices(obj,fid,FM)
%Write_SUBRoutine_Output_Matrices
%
%   This generates a subroutine in the file: "Generic_FEM_Assembly.cc".

% Copyright (c) 06-19-2012,  Shawn W. Walker

ENDL = '\n';
TAB = '    ';
TAB2 = [TAB, TAB];
%%%%%%%
fprintf(fid, ['', ENDL]);
fprintf(fid, ['', obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['', '/***************************************************************************************/', ENDL]);
fprintf(fid, ['', '/* this outputs all FEM matrices as MATLAB sparse matrices */', ENDL]);
fprintf(fid, ['', 'void GFA::Output_Matrices (mxArray* plhs[])', ENDL]);
fprintf(fid, ['', '{', ENDL]);
fprintf(fid, [TAB, '// declare internal matrix data storage pointer', ENDL]);
fprintf(fid, [TAB, 'mxArray* Sparse_ptr;', ENDL]);
fprintf(fid, ['', '', ENDL]);
fprintf(fid, [TAB, '// create sparse MATLAB matrices and pass them back to MATLAB', ENDL]);
fprintf(fid, ['', '', ENDL]);

Matrix_Names = FM.Matrix.keys;
NUM_MAT = length(Matrix_Names);
for index = 1:NUM_MAT
    MAT_CPP = FM.Get_Matrix_CPP_Info(Matrix_Names{index});
    fprintf(fid, [TAB, 'Sparse_ptr = ', MAT_CPP.Var_Name, '->MAT->export_matrix();', ENDL]);
    cpp_ind = num2str(index-1);
    fprintf(fid, [TAB, 'Output_Matrix(', cpp_ind, ', Sparse_ptr, ',...
                       'mxCreateString(', MAT_CPP.Var_Name, '->Name)',...
                       ', plhs[0]);', ENDL]);
    fprintf(fid, [TAB, 'delete(', MAT_CPP.Var_Name, ');', ENDL]);
    fprintf(fid, ['', '', ENDL]);
end

fprintf(fid, ['', '}', ENDL]);
fprintf(fid, ['', '/***************************************************************************************/', ENDL]);
status = fprintf(fid, ['', obj.END_Auto_Gen, ENDL]);

end