function status = Gen_Coef_Function_Class_Defn(obj,fid,BasisFunc,CF_CODE)
%Gen_Coef_Function_Class_Defn
%
%   This declares the Coef_Function_Class definition.

% Copyright (c) 03-14-2012,  Shawn W. Walker

ENDL = '\n';
TAB = '    ';
TAB2 = [TAB, TAB];
%%%%%%%
% write the definition!
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['/***************************************************************************************/', ENDL]);
fprintf(fid, ['/* C++ (Specific) FEM Function class definition */', ENDL]);
fprintf(fid, ['class SpecificFUNC', ENDL]);
fprintf(fid, ['{', ENDL]);
fprintf(fid, ['public:', ENDL]);
fprintf(fid, [TAB, '// pointer to basis function that drives this coefficient function', ENDL]);
Basis_Func_Data_Type_str = ['const ', BasisFunc.CPP_Data_Type, '*'];
BASIS_DECLARE_str = [BasisFunc.CPP_Data_Type, '*     ', 'basis_func', ';'];
fprintf(fid, [TAB, 'const ', BASIS_DECLARE_str, ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, [TAB, 'double*  Node_Value[NC];  // node values', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, [TAB, 'char*    Name;              // specifies the name of the finite element function itself', ENDL]);
fprintf(fid, [TAB, 'char*    CPP_Routine;       // specifies the name of the C++ routine itself (only needed for debugging)', ENDL]);
fprintf(fid, [TAB, 'char*    Type;              // specifies the name of function space (only needed for debugging)', ENDL]);
fprintf(fid, [TAB, 'int      Num_Nodes;         // number of nodes (number of global DoFs)', ENDL]);
fprintf(fid, [TAB, 'int      Num_Comp;          // number of (scalar) components (i.e. is it a vector or scalar?)', ENDL]);
fprintf(fid, [TAB, 'int      Num_QP;            // number of quadrature points used', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, [TAB, '// data structure containing information on the function evaluations.', ENDL]);
fprintf(fid, [TAB, '// Note: this data is evaluated at several quadrature points!', ENDL]);
% write the coef. function variable declarations
for ind=1:length(CF_CODE)
    DECLARE = CF_CODE(ind).Defn;
    for di=1:length(DECLARE)
        fprintf(fid, [TAB, DECLARE(di).line, ENDL]);
    end
end
fprintf(fid, ['', ENDL]);
fprintf(fid, [TAB, '// constructor', ENDL]);
fprintf(fid, [TAB, 'SpecificFUNC ();', ENDL]);
fprintf(fid, [TAB, '~SpecificFUNC (); // destructor', ENDL]);
fprintf(fid, [TAB, 'void Setup_Function_Space(const mxArray*, ', Basis_Func_Data_Type_str, ');', ENDL]);
fprintf(fid, [TAB, 'void Compute_Func();', ENDL]);
fprintf(fid, ['', 'private:', ENDL]);
fprintf(fid, ['', '};', ENDL]);
fprintf(fid, [obj.END_Auto_Gen, ENDL]);
status = fprintf(fid, ['', ENDL]);

end