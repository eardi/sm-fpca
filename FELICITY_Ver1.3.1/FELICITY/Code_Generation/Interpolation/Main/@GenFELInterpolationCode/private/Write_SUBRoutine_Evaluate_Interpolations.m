function status = Write_SUBRoutine_Evaluate_Interpolations(obj,fid,FS,FI)
%Write_SUBRoutine_Evaluate_Interpolations
%
%   This generates a subroutine in the file: "Generic_FEM_Interpolation.cc".

% Copyright (c) 01-29-2013,  Shawn W. Walker

ENDL = '\n';
%%%%%%%
fprintf(fid, ['', ENDL]);
fprintf(fid, ['', obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['', '/***************************************************************************************/', ENDL]);
fprintf(fid, ['', '/* here is the main calling routine for interpolating */', ENDL]);
fprintf(fid, ['', 'void GFI::Evaluate_Interpolations ()', ENDL]);
fprintf(fid, ['', '{', ENDL]);
fprintf(fid, ['    ', 'unsigned int Num_DoE_Interp_Pts = 0;', ENDL]);
fprintf(fid, ['', '', ENDL]);

% loop through all of the distinct domains of interpolation!
Interp_Domains = FI.Get_Distinct_Domains();
for ind = 1:length(Interp_Domains)
    INT_DOM = Interp_Domains{ind};
    Write_Evaluate_Interpolations_On_Expression_Domain(fid,FS,FI,INT_DOM);
end

fprintf(fid, ['', '}', ENDL]);
fprintf(fid, ['', '/***************************************************************************************/', ENDL]);
status = fprintf(fid, ['', obj.END_Auto_Gen, ENDL]);

end