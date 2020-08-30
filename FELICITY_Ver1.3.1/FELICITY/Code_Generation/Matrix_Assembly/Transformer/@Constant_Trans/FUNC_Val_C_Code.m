function CODE = FUNC_Val_C_Code(obj)
%FUNC_Val_C_Code
%
%   Generate C-code for direct evaluation of global constant basis function
%   C.

% Copyright (c) 01-20-2018,  Shawn W. Walker

% make var string
C_Val_str = obj.Output_CPP_Var_Name('Val');
%C_Val_str_PTR = obj.Output_CPP_Var_Name_Pointer_DeRef('Val');

if obj.INTERPOLATION
    % create struct manually (this is for generating interpolation code)
    TYPE_str = obj.Get_CPP_Scalar_Data_Type_Name;
    CODE.Var_Name(1).line = [];
    CODE.Var_Name(1).line = C_Val_str;
    %CODE.Var_Name(2).line = C_Val_str;
    CODE.Constant  = obj.Is_Quantity_Constant('Val');
    CODE.Defn(2).line = [];
    CODE.Defn(1).line = '// global function value is constant 1.0 everywhere';
    CODE.Defn(2).line = ['static const  ', TYPE_str, '  ', CODE.Var_Name(1).line, '', ';'];
    
%     % make (local) basis function derivative eval strings
%     BF_Val = 'phi_Val.a';
    
    CODE.Eval_Snip(2).line = [];
    CODE.Eval_Snip(1).line = '// set basis function values to the correct mesh entity';
    CODE.Eval_Snip(2).line = ['ERROR: this should not be used!']; % this is not used!
else
    % create struct manually (this is a special case)
    TYPE_str = obj.Get_CPP_Scalar_Data_Type_Name;
    CODE.Var_Name(1).line = [];
    CODE.Var_Name(1).line = C_Val_str;
    %CODE.Var_Name(2).line = C_Val_str_PTR;
    CODE.Constant  = obj.Is_Quantity_Constant('Val');
    CODE.Defn(2).line = [];
    CODE.Defn(1).line = '// global function value is constant 1.0 everywhere';
    CODE.Defn(2).line = ['static const  ', TYPE_str, '  ', CODE.Var_Name(1).line, '', ';'];
    
    CODE.Eval_Snip(2).line = [];
    CODE.Eval_Snip(1).line = '// set basis function values to the correct mesh entity';
    CODE.Eval_Snip(2).line = ['ERROR: this should not be used!']; % this is not used!
end

end