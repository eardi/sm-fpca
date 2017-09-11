function display(obj)

disp('------------------------------------------------');
disp('FELMatrices Object:');
disp(' ');

disp(['           Matrix: containers.Map Containing Info About the FE Matrices:  ','']);
disp('');
Matrix_Names = obj.Matrix.keys;
for ind = 1:length(Matrix_Names)
    disp(['FE Matrix Name (key): ', Matrix_Names{ind}]);
    disp(obj.Matrix(Matrix_Names{ind}));
end
disp('');
disp(['      Integration: List of All Integration Domains:   ','Number of Domains = ', num2str(length(obj.Integration))]);
disp('');
disp(obj.Integration(1));

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