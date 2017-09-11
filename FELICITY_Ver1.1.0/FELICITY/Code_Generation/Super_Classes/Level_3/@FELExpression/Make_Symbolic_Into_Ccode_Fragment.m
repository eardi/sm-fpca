function Ccode_Frag = Make_Symbolic_Into_Ccode_Fragment(obj,Symbolic,Var_Names,Replace)
%Get_Eval_Func_String
%
%   This will convert the symbolic expression into a C-code fragment.

% Copyright (c) 06-12-2014,  Shawn W. Walker

% make a temp file
Frag_File = 'C_code_frag.c';
Ccode_File = fullfile(obj.Snippet_Dir, Frag_File);

Ccode_File_status = dir(Ccode_File);
if ~isempty(Ccode_File_status)
    % make sure nothing is there to start
    delete(Ccode_File);
end

% generate optimized C-code from symbolic expression
ccode(sym(Symbolic),'file',Ccode_File);

% BEGIN: read the generated code back
fid_frag = fopen(Ccode_File, 'r');

Ccode_Frag(1).line = [];
line_cnt = 0;
while true
    tline = fgetl(fid_frag);
    if ~ischar(tline), break, end
    line_cnt = line_cnt + 1;
    Ccode_Frag(line_cnt).line = tline;
end
fclose(fid_frag);
% END: read the generated code back

% only make replacements if there are actually things to replace!
if ~isempty(Replace)
    % replace each variable with the actual C-code variable replacement
    REPLACE_TF = false(length(Replace),1);
    for line_ind = 1:line_cnt
        for rep_ind = 1:length(Replace)
            NEW_line = regexprep(Ccode_Frag(line_ind).line, char(Var_Names(rep_ind)), Replace(rep_ind).str);
            if ~strcmp(Ccode_Frag(line_ind).line,NEW_line)
                % then the replacement must have happened
                REPLACE_TF(rep_ind) = true; % keep track of what is replaced!
            end
            Ccode_Frag(line_ind).line = NEW_line;
        end
    end
    % if at least one variable never got replaced, then something is wrong!
    [Val, Rep_Ind] = min(REPLACE_TF);
    if (Val==0)
        disp('ERROR: variable name replacement failed: ');
        disp(['       ', char(Var_Names(Rep_Ind)), '  <---  ', Replace(Rep_Ind).str]);
        disp('       in the symbolic expression: ');
        disp(['       ', char(Symbolic)]);
        disp('DEBUG info: ');
        disp('            all text strings: ');
        for ci=1:length(Ccode_Frag)
            disp(['Line ', num2str(ci), ': ', Ccode_Frag(ci).line]);
        end
        error('ERROR: please report this bug!');
    end
end

end