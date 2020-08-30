function status = Write_SUBRoutine_Transform_Basis_Functions(obj,fid,Compute_Local_Transformation)
%Write_SUBRoutine_Transform_Basis_Functions
%
%   This generates a sub-routine of the Basis_Function_Class for computing
%   transformations of the local basis functions.

% Copyright (c) 01-16-2018,  Shawn W. Walker

ENDL = '\n';
TAB = '    ';
%%%%%%%
% main transform basis function code
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['/***************************************************************************************/', ENDL]);
fprintf(fid, ['/* compute the correct local transformation */', ENDL]);
fprintf(fid, ['void SpecificFUNC::Transform_Basis_Functions()', ENDL]);
fprintf(fid, ['{', ENDL]);

% only write this when the basis function is NOT a global constant!
if ~isa(obj.FuncTrans,'Constant_Trans')
    fprintf(fid, [Compute_Local_Transformation.Main_Subroutine, ENDL]);
end

fprintf(fid, ['}', ENDL]);
fprintf(fid, ['/***************************************************************************************/', ENDL]);
fprintf(fid, [obj.END_Auto_Gen, ENDL]);
status = fprintf(fid, ['', ENDL]);

end