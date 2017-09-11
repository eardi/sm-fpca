function [obj, Replacement_str] = Get_Eval_String(obj,input_str,var_str,Geo_Dim)
%Get_Eval_String
%
%   This will parse the coefficient function string.  It also sets the options
%   (.Opt) of the function.

% Copyright (c) 03-26-2012,  Shawn W. Walker

% init
Replacement_str = [];
len_var_str = length(var_str);

% rough validity check
if length(input_str) < (len_var_str+6)
    %     disp('Input argument string not long enough!');
    %     var_str
    return;
end
% make sure the *beginning of input_str* matches var_str!
if ~strncmp(input_str,var_str,len_var_str)
%     disp('The input_str and var_str are completely different!');
%     input_str
%     var_str
    return;
end

[Vector_Comp, Tensor_Comp] = obj.Parse_Vector_Tensor_Components(input_str,var_str);
Tensor_Comp_c_ind_STR = ['[', num2str(Tensor_Comp-1), ']'];

coef_func_STR  = [obj.CPP_Var, '->'];

% setup matching strings
CONST_ELEM = ReferenceFiniteElement(constant_one(),1,true);
BF = FiniteElementBasisFunction(CONST_ELEM);
MATCH_STR = BF.Get_String_Match_Struct;
clear BF CONST_ELEM;

% check if it is the hessian of the function
if ~isempty(regexp(input_str,[var_str, MATCH_STR.hess], 'once'))
    
    obj.Opt.Hess = true;
    % parse the hessian components
    Hess_Comp_1_str = input_str(len_var_str+12);
    Hess_Comp_2_str = input_str(len_var_str+13);
    Hess_Comp       = [str2double(Hess_Comp_1_str), str2double(Hess_Comp_2_str)];
    if ( max(Hess_Comp) > Geo_Dim )
        error('Cannot use derivatives beyond the geometric dimension.');
    end
    Comp = [Vector_Comp, Hess_Comp];
    Replacement_str = Func_Coef_Replacement('Hess',obj.FuncTrans,Comp,coef_func_STR,Tensor_Comp_c_ind_STR);

% check if it is the gradient of the function
elseif ~isempty(regexp(input_str,[var_str, MATCH_STR.grad], 'once'))
    
    obj.Opt.Grad = true;
    % parse the gradient component
    Grad_Comp_str = input_str(len_var_str+12);
    Grad_Comp     = str2double(Grad_Comp_str);
    if Grad_Comp > Geo_Dim
        error('Cannot use derivatives beyond the geometric dimension.');
    end
    Comp = [Vector_Comp, Grad_Comp];
    Replacement_str = Func_Coef_Replacement('Grad',obj.FuncTrans,Comp,coef_func_STR,Tensor_Comp_c_ind_STR);
    
% check if it is the divergence operator
elseif ~isempty(regexp(input_str,[var_str, MATCH_STR.div], 'once'))
    
    obj.Opt.Div = true;
    if (obj.Elem.Num_Vec_Comp < 2)
        error('Can only use "div" operator on functions that are intrinsically vector-valued.');
    end
    Replacement_str = Func_Coef_Replacement('Div',obj.FuncTrans,Vector_Comp,coef_func_STR,Tensor_Comp_c_ind_STR);
    
% check if it is the 2nd arc-length derivative along a curve
elseif ~isempty(regexp(input_str,[var_str, MATCH_STR.dsds], 'once'))
    
    obj.Opt.d2_ds2 = true;
    if obj.Elem.Top_Dim > 1
        error('Cannot use 2nd arc-length derivative in topological dimensions greater than 1.');
    end
    Replacement_str = Func_Coef_Replacement('d2_ds2',obj.FuncTrans,Vector_Comp,coef_func_STR,Tensor_Comp_c_ind_STR);

% check if it is the 1st arc-length derivative along a curve
elseif ~isempty(regexp(input_str,[var_str, MATCH_STR.ds], 'once'))
    
    obj.Opt.d_ds = true;
    if obj.Elem.Top_Dim > 1
        error('Cannot use 1st arc-length derivative in topological dimensions greater than 1.');
    end
    Replacement_str = Func_Coef_Replacement('d_ds',obj.FuncTrans,Vector_Comp,coef_func_STR,Tensor_Comp_c_ind_STR);
    
% check if it is the value of the function
elseif ~isempty(regexp(input_str,[var_str, MATCH_STR.val], 'once'))
    
    obj.Opt.Val = true;
    Replacement_str = Func_Coef_Replacement('Val',obj.FuncTrans,Vector_Comp,coef_func_STR,Tensor_Comp_c_ind_STR);
    
end

if ~isempty(Replacement_str)
    if ~isa(obj.FuncTrans,'H1_Trans')
        % for non-H^1 functions, we always need the orientation (of the "facets")
        obj.Opt.Orientation = true;
    end
end

end

function STR = Func_Coef_Replacement(FIELD_STR,FuncTrans,Comp,coef_func_STR,Tensor_Comp_STR)

CPP_Name        = FuncTrans.Output_CPP_Var_Name(FIELD_STR);
CPP_Name_w_CF   = [coef_func_STR, CPP_Name];

STR_begin = [CPP_Name_w_CF, Tensor_Comp_STR, '[qp]'];
Eval_Ext = FuncTrans.Output_CPP_Eval_Extension(FIELD_STR,Comp);
STR = [STR_begin, Eval_Ext];

end