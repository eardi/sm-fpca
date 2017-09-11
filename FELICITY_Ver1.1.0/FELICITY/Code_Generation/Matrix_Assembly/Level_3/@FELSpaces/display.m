function display(obj)

disp('------------------------------------------');
disp(['FELSpaces Object:']);
disp(' ');

disp(['            Space: containers.Map Containing Info About the FE Spaces:  ','']);
disp('');
Space_Names = obj.Space.keys;
for ind = 1:length(Space_Names)
    disp(['FE Space Name (key): ', Space_Names{ind}]);
    disp(obj.Space(Space_Names{ind}));
end
disp('');

disp(['      Integration: List of All Integration Domains:   ','Number of Domains = ', num2str(length(obj.Integration))]);
disp('');
disp(obj.Integration(1));

disp('');
if obj.DEBUG
    DEBUG = 'TRUE';
else
    DEBUG = 'FALSE';
end
disp(['            DEBUG: Perform Debugging Checks                          =  ',DEBUG]);

end