function display(obj)

% % get number of objects
% Num_Obj = length(obj);

% for oi=1:Num_Obj

% disp('------------------------------------------');
% disp(['FFL(',num2str(oi),')']);
% disp('');

disp(['        Num_Funcs: Number of Coefficient Functions                  ',' = ',num2str(obj.Num_Funcs)]);
disp(['            Func : Struct Containing Info About the Spaces:         ','']);
disp('');

disp(obj.Func);

disp('');
if obj.DEBUG
    DEBUG = 'TRUE';
else
    DEBUG = 'FALSE';
end
disp(['            DEBUG: Perform Debugging Checks                          =  ',DEBUG]);

% disp('');
% disp('------------------------------------------');
% disp('');

% end

end