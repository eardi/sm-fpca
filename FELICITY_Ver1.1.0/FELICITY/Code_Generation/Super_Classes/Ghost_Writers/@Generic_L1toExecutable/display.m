function display(obj)

disp('------------------------------------------');
disp(['Generic_L1toExecutable:']);
disp('');

disp(['      Snippet_Dir: Location Temporary Code Snippets                ',' = ','''', obj.Snippet_Dir, '''']);
disp(['      GenCode_Dir: Location of Auto-Generated Code                 ',' = ','''', obj.GenCode_Dir, '''']);
disp(['      MEXFile_Dir: Location of Compiled MEX File                   ',' = ','''', obj.MEXFile_Dir, '''']);

if obj.DEBUG
    DEBUG = 'TRUE';
else
    DEBUG = 'FALSE';
end
disp(['            DEBUG: Perform Debugging Checks                         =  ',DEBUG]);

disp('');
disp('------------------------------------------');
disp('');

end