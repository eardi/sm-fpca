function status = Write_SUBRoutine_Assemble_Matrices(obj,fid,FS,FM)
%Write_SUBRoutine_Assemble_Matrices
%
%   This generates a subroutine in the file: "Generic_FEM_Assembly.cc".

% Copyright (c) 06-04-2012,  Shawn W. Walker

ENDL = '\n';
%%%%%%%
fprintf(fid, ['', ENDL]);
fprintf(fid, ['', obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['', '/***************************************************************************************/', ENDL]);
fprintf(fid, ['', '/* here is the main calling routine for assembling all FEM matrices */', ENDL]);
fprintf(fid, ['', 'void GFA::Assemble_Matrices ()', ENDL]);
fprintf(fid, ['', '{', ENDL]);
% fprintf(fid, ['    ', '//unsigned int Num_DoI_Elem = 0;', ENDL]);
% fprintf(fid, ['', '', ENDL]);

% loop through all of the domains of integration!
for ind = 1:length(FS.Integration)
    Write_Assemble_Matrices_On_Integration_Domain(fid,FS,FM,ind);
end

fprintf(fid, ['', '}', ENDL]);
fprintf(fid, ['', '/***************************************************************************************/', ENDL]);
status = fprintf(fid, ['', obj.END_Auto_Gen, ENDL]);

end