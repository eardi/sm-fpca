function display(obj)

disp(['   Default_Dir     : Directory to Store Log File                ',' = ',obj.Default_Dir]);
disp(['   Default_FileName: Filename to Write Log File to              ',' = ',obj.Default_FileName]);
disp(['        Log_Comment: Struct Containing All of the Log Comments  ','']);
disp(obj.Log_Comment);

if obj.DEBUG
    DEBUG = 'TRUE';
else
    DEBUG = 'FALSE';
end
disp(['              DEBUG: Perform Debugging Checks                    = ',DEBUG]);
disp(['               ENDL: Endline Character                          ',' = ',obj.ENDL]);

% disp('');
% disp('------------------------------------------');
% disp('');

% end

end