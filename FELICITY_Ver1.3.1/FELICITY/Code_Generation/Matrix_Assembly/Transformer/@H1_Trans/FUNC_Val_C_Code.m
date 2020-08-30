function CODE = FUNC_Val_C_Code(obj)
%FUNC_Val_C_Code
%
%   Generate C-code for direct evaluation of f.
%            f_k(qp) = phi_k(qp), where f_k is the kth basis function, and
%                        qp are the coordinates of a quadrature point.

% Copyright (c) 10-27-2016,  Shawn W. Walker

% make var string
f_Val_str = obj.Output_CPP_Var_Name('Val');
f_Val_str_PTR = obj.Output_CPP_Var_Name_Pointer_DeRef('Val');

if obj.INTERPOLATION
    % create struct manually (this is for generating interpolation code)
    TYPE_str = obj.Get_CPP_Scalar_Data_Type_Name;
    CODE.Var_Name(1).line = [];
    CODE.Var_Name(1).line = f_Val_str;
    %CODE.Var_Name(2).line = f_Val_str;
    CODE.Constant  = obj.Is_Quantity_Constant('Val');
    CODE.Defn(2).line = [];
    CODE.Defn(1).line = '// actually, the "quadrature" point is an interpolation point in the reference element';
    CODE.Defn(2).line = [TYPE_str, '  ', CODE.Var_Name(1).line, '[NB][NQ];'];
    
    % make (local) basis function derivative eval strings
    BF_Val = 'phi_Val[basis_i].a';
    
    TAB = '    ';
    CODE.Eval_Snip(6).line = [];
    CODE.Eval_Snip(1).line = '// copy function evaluations over (indexing is in the C style)';
    CODE.Eval_Snip(2).line = '// evaluate for each basis function';
    CODE.Eval_Snip(3).line = 'for (int basis_i = 0; (basis_i < Num_Basis); basis_i++)';
    CODE.Eval_Snip(4).line = [TAB, '{'];
    CODE.Eval_Snip(5).line = [TAB, f_Val_str, '[basis_i][0].a = ', BF_Val, ';'];
    CODE.Eval_Snip(6).line = [TAB, '}'];
else
    % create struct manually (this is a special case)
    TYPE_str = obj.Get_CPP_Scalar_Data_Type_Name;
    CODE.Var_Name(2).line = [];
    CODE.Var_Name(1).line = f_Val_str;
    CODE.Var_Name(2).line = f_Val_str_PTR;
    CODE.Constant  = obj.Is_Quantity_Constant('Val');
    CODE.Defn(3).line = [];
    CODE.Defn(1).line = '// local function evaluated at a quadrature point in reference element';
    CODE.Defn(2).line = '// (this is a pointer because it will change depending on the local mesh entity)';
    CODE.Defn(3).line = [TYPE_str, '  ', CODE.Var_Name(2).line, '[NB][NQ];'];
    
    CODE.Eval_Snip(2).line = [];
    CODE.Eval_Snip(1).line = '// set basis function values to the correct mesh entity';
    %CODE.Eval_Snip(2).line = [CODE.Var_Name(1).line, ' = &', Compute_Map.Val_VarName, ';'];
    CODE.Eval_Snip(2).line = ['ERROR']; % this line must be handled elsewhere!
end

end