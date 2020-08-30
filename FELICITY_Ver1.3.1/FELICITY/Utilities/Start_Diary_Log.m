function Start_Diary_Log(Dir,FileName)
%Start_Diary_Log
%
%   This starts MATLAB's diary command.
%
%   Start_Diary_Log(Dir,FileName);
%
%   Dir = directory to store the diary in.
%   FileName = desired file name of the diary.

% Copyright (c) 12-10-2010,  Shawn W. Walker

if ~isdir(Dir)
    error('Given directory is NOT valid.');
end

date_now = clock;
date_now_str = [num2str(date_now(1)),'_',num2str(date_now(2)),'_', num2str(date_now(3)), '_',...
                num2str(date_now(4)), 'hr_', num2str(date_now(5)), 'min'];
%
Log_File = [FileName, '_', date_now_str, '.log'];
Complete_FN = fullfile(Dir, Log_File);
diary(Complete_FN);

end