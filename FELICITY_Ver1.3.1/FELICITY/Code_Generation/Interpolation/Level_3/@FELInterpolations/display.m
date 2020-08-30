function display(obj)

disp('------------------------------------------------');
disp('FELInterpolations Object:');
disp(' ');

disp(['             keys: keys to the containers.Map Interp:  ','']);
disp('');
Interp_Names = obj.keys;
for ind = 1:length(Interp_Names)
    disp(['Interpolation Name (key): ', Interp_Names{ind}]);
end
disp('');
disp(['           Interp: Container of All Interpolations:                ','Number of Interpolations = ', num2str(length(obj.Interp))]);
disp('');
disp(obj.Interp);

disp(['      Snippet_Dir: sub-directory to store minor code snippets      ',' = ','''', obj.Snippet_Dir, '''']);
disp('');

disp('');
if obj.DEBUG
    DEBUG = 'TRUE';
else
    DEBUG = 'FALSE';
end
disp(['            DEBUG: Perform Debugging Checks                         =  ',DEBUG]);

% disp('');
% disp('------------------------------------------');
% disp('');

% end

end