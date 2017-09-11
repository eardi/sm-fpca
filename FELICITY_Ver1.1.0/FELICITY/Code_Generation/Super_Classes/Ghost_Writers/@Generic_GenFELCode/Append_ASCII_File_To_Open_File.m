function status = Append_ASCII_File_To_Open_File(obj,Fixed_File,fid_Open)
%Append_ASCII_File_To_Open_File
%
%   This appends a fixed ASCII file to a currently open file.

% Copyright (c) 04-07-2010,  Shawn W. Walker

% verify that the file exists!
Dstat = dir(Fixed_File);
if isempty(Dstat)
    disp(['ERROR: the file ''', Fixed_File, ''' does not exist!']);
    error('Check the filename!');
end

fid_fixed = fopen(Fixed_File, 'r');

while true
    tline = fgets(fid_fixed);
    if ~ischar(tline), break, end
    
    % fix any percent signs or backslashes
    tline = obj.Double_Percent_and_Backslash(tline);
    
    %disp(tline);
    fprintf(fid_Open, tline);
end
status = fclose(fid_fixed);

end