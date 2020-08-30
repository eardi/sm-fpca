function Parsed_Text = Read(obj)
%Read
%
%   This will read a text file and store it in an array of structs.
%
%   Parsed_Text = obj.Read;
%
%   Parsed_Text = struct containing the lines of the text file.

% Copyright (c) 04-10-2010,  Shawn W. Walker

Fixed_File = obj.FileName;

% verify that the file exists!
Dstat = dir(Fixed_File);
if isempty(Dstat)
    disp(['ERROR: the file ''', Fixed_File, ''' does not exist!']);
    error('Check the filename!');
end

disp(['*Open  file: ''', Fixed_File, '''']);
fid_in = fopen(Fixed_File, 'r');

% first, read in the whole thing and filter out comments!
code_cnt = 0;
line_cnt = 0;
while true
    % read in line
    tline = fgetl(fid_in);
    if ~ischar(tline), break, end
    line_cnt = line_cnt + 1;
    
    % strip out comments
    tline_no_comment = regexprep(tline, '\s*#.*', '');
    % make sure to ignore lines that are just white-space
    is_tline_just_whitespace = regexprep(tline_no_comment, '\s*', '');
    % if that line was not just a comment (and not just blank space)
    if and(~isempty(tline_no_comment),~isempty(is_tline_just_whitespace))
        % make semi-colon last!
        tline_no_comment = regexprep(tline_no_comment, ';\s*', ';');
        if ~strcmp(tline_no_comment(end),';') % make sure last char is a semi-colon
            disp('--------------------------------');
            ERR_STR = ['ERROR: Line #', num2str(line_cnt), ' of ''', Fixed_File, ''' does not end with '';''.'];
            disp(ERR_STR);
            disp('--------------------------------');
            fclose(fid_in);
            error(['Fix this file: ', Fixed_File]);
        end
        TEMP_PARSE.line_char = tline_no_comment;
        TEMP_PARSE.line_cnt  = line_cnt;
        code_cnt = code_cnt + 1;
        Parsed_Text(code_cnt) = TEMP_PARSE;
    end
end
disp(['*Close file: ''', Fixed_File, '''']);
status = fclose(fid_in);
if status~=0
    disp('--------------------------------');
    disp(['This file did not close properly: ''', Fixed_File, '''']);
    disp(['status = ', num2str(status,'%d')]);
    disp('--------------------------------');
    error('Find out what went wrong!');
end

% END %