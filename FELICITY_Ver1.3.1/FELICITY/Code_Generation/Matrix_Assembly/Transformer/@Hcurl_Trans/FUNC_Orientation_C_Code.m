function CODE = FUNC_Orientation_C_Code(obj)
%FUNC_Orientation_C_Code
%
%   Generate C-code for direct evaluation of orientation of the vector basis
%   functions.

% Copyright (c) 03-22-2012,  Shawn W. Walker

error('do not use!');

% make var string
vv_Orient_str = obj.Output_CPP_Var_Name('Orientation');

% loop thru all components of the map
EVAL_STR(1).line = []; % init

% define the data type
TYPE_str = obj.Get_CPP_Scalar_Data_Type_Name;
Defn_Hdr = '// orientation of each vector basis function';
Loop_Hdr = '';
Loop_Comment = '// get orientation of each basis (vector) function';
CONST_VAR = obj.Is_Quantity_Constant('Orientation');
CODE = obj.create_basis_func_declaration_and_eval_code(vv_Orient_str,TYPE_str,EVAL_STR,...
                             Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
%

% must compute this elsewhere!
CODE.Eval_Snip = [];
CODE.Eval_Snip(2).line = [];
CODE.Eval_Snip(1).line = '// see orientation computation above! (REMOVE THIS!!!!)';
CODE.Eval_Snip(2).line = '';

end