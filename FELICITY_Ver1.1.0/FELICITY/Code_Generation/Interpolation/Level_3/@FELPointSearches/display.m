function display(obj)

disp('------------------------------------------------');
disp('FELPointSearches Object:');
disp(' ');

disp(['             keys: keys to the containers.Map GeomFuncs (which are domain names):  ','']);
disp('');
Domain_Names = obj.keys;
for ind = 1:length(Domain_Names)
    disp(['Domain Name (key): ', Domain_Names{ind}]);
end
disp('');
disp(['        GeomFuncs: Container of Geometric Functions representing point search domains: ','Number = ', num2str(length(obj.GeomFuncs))]);
disp('');
disp(obj.GeomFuncs);

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

end