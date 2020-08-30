function status = Write_C_Code_To_File(obj,FileName,Struct_C_Code)
%Write_C_Code_To_File
%
%   This writes a given code struct and writes it to a given file.

% Copyright (c) 02-20-2012,  Shawn W. Walker

% open file for writing
fid = fopen(FileName, 'w');

if ~isempty(Struct_C_Code)
    
    % write the variable names
    write_code_line(fid,'// Variable Names:');
    write_code_line(fid,'// -----------------------');
    for ind=1:length(Struct_C_Code.Var_Name(:))
        write_code_line(fid, Struct_C_Code.Var_Name(ind).line);
    end
    write_CR(fid);
    
    % write the definition code
    write_code_line(fid,'// Definition Code:');
    write_code_line(fid,'// ------------------------');
    for ind=1:length(Struct_C_Code.Defn)
        write_code_line(fid, Struct_C_Code.Defn(ind).line);
    end
    write_CR(fid);
    
    % write the evaluation code
    write_code_line(fid,'// Evaluation Code:');
    write_code_line(fid,'// ------------------------');
    for ind=1:length(Struct_C_Code.Eval_Snip)
        write_code_line(fid, Struct_C_Code.Eval_Snip(ind).line);
    end
    write_CR(fid);
    
else
    write_code_line(fid,'// EMPTY!!!!!!!!');
    write_CR(fid);
end

% DONE!
status = fclose(fid);

end

function status = write_code_line(fid,STR)

ENDL = '\n';
if ~isempty(STR)
    status = fprintf(fid, [STR, ENDL]);
end

end

function status = write_CR(fid)

ENDL = '\n';
status = fprintf(fid, ['', ENDL]);

end