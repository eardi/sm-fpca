function display(obj)

disp('------------------------------------------');
disp(['FiniteElementCoefFunction:']);
disp('');

display@GenericFiniteElementFunction(obj);

disp(['       Space_Name: Name of Finite Element Space                  ',' = ',obj.Space_Name]);
disp(['              Opt: Struct Indicating Needed Function Quantities:   ','']);
disp('');
disp(obj.Opt);
disp('');
disp(['        FuncTrans: Transformer Object (for computing quantites in Opt) ', '']);
disp('');
disp(obj.FuncTrans);
disp('');
disp(['    CPP_Data_Type: C++ Data Type Name (for code generation)              ',' = ',obj.CPP_Data_Type]);
disp(['    CPP_Var      : C++ Variable  Name (for code generation)              ',' = ',obj.CPP_Var]);

end