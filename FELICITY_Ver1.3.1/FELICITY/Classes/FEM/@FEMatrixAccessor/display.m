function display(obj)

disp('------------------------------------------');
disp(['FEMatrixAccessor:']);
disp(' ');

disp(['            Name: Identifier                                =  ''',obj.Name,'''']);
disp(['             FEM: Finite Element Matrix Data                     ','']);

Num_FEM = length(obj.FEM);

for ind = 1:Num_FEM
    disp(obj.FEM(ind));
end

disp('------------------------------------------');
disp(' ');

end