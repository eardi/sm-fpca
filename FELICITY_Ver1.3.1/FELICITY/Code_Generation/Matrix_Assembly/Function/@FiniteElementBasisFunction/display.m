function display(obj)

disp('------------------------------------------');
disp(['FiniteElementBasisFunction:']);
disp('');

display@GenericFiniteElementFunction(obj);

disp(['       Space_Name: Name of Finite Element Space                          ',' = ',obj.Space_Name]);
disp(['             Type: Type of Function                                      ',' = ',obj.Type]);
disp(['              Opt: Struct Indicating Needed Function Quantities:         ','']);
disp('');
disp(obj.Opt);
disp('');
disp(['         GeomFunc: GeometricElementFunction For This Basis Function:   ', '']);
disp('');
disp(obj.GeomFunc);
disp('');
disp(['        FuncTrans: Transformer Object (for computing quantites in Opt)   ', '']);
disp('');
disp(obj.FuncTrans);
disp('');
disp(['    CPP_Data_Type: C++ Data Type Name (for code generation)              ',' = ',obj.CPP_Data_Type]);
disp(['    CPP_Var      : C++ Variable  Name (for code generation)              ',' = ',obj.CPP_Var]);

end