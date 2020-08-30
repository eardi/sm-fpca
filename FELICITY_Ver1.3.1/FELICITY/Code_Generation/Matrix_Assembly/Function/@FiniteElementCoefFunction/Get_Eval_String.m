function [obj, Replacement_str] = Get_Eval_String(obj,input_str,var_str,Geo_Dim,Num_Tuple_in_FE_Space)
%Get_Eval_String
%
%   This will parse the coefficient function string.  It also sets the options
%   (.Opt) of the function.

% Copyright (c) 12-15-2017,  Shawn W. Walker

% init
Replacement_str = [];
len_var_str = length(var_str);

% BEGIN: some simple checks

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

% END: some simple checks

% setup matching strings
CONST_ELEM = ReferenceFiniteElement(constant_one(),true);
BF = FiniteElementBasisFunction(CONST_ELEM);
MATCH_STR = BF.Get_String_Match_Struct;
clear BF CONST_ELEM;

% ultimate check
MATCH_STR_cell = struct2cell(MATCH_STR);
input_str_stripped = obj.Strip_String_Suffix(input_str,MATCH_STR_cell);
clear MATCH_STR_cell;
if ~strcmp(input_str_stripped,var_str)
    % 'input_str_stripped' should match 'var_str' exactly, else return
%     disp('The input_str_stripped and var_str are not exactly the same!');
%     input_str_stripped
%     var_str
    return;
end

% vector and tuple index string stuff
[Basis_Comp, Tuple_Comp] = obj.Parse_Vector_Tensor_Components(input_str,var_str,Num_Tuple_in_FE_Space);
% convert to linear index k = i + (j-1)*m, where m (n) is the number of rows (cols) in the tuple size,
%     and   1 <= i <= m,  1 <= j <= n
Tuple_Comp_Linear_Index = Tuple_Comp(1) + (Tuple_Comp(2)-1) * Num_Tuple_in_FE_Space(1);
Tuple_Comp_c_ind_STR = ['[', num2str(Tuple_Comp_Linear_Index - 1), ']'];

coef_func_STR  = [obj.CPP_Var, '->'];

% check if it is the hessian of the function
if ~isempty(regexp(input_str,[var_str, MATCH_STR.hess], 'once'))
    
    str_match_cell = regexp(input_str,[var_str, MATCH_STR.hess], 'match');
    str_match = str_match_cell{1};
    
    obj.Opt.Hess = true;
    % parse the hessian components
    Hess_Comp_1_str = str_match(end-1);
    Hess_Comp_2_str = str_match(end);
    Hess_Comp       = [str2double(Hess_Comp_1_str), str2double(Hess_Comp_2_str)];
    if ( max(Hess_Comp) > Geo_Dim )
        error('Cannot use derivatives beyond the geometric dimension.');
    end
    Comp = [Basis_Comp, Hess_Comp];
    Replacement_str = Func_Coef_Replacement('Hess',obj.FuncTrans,Comp,coef_func_STR,Tuple_Comp_c_ind_STR);

% check if it is the gradient of the function
elseif ~isempty(regexp(input_str,[var_str, MATCH_STR.grad], 'once'))
    
    str_match_cell = regexp(input_str,[var_str, MATCH_STR.grad], 'match');
    str_match = str_match_cell{1};
    
    obj.Opt.Grad = true;
    % parse the gradient component
    Grad_Comp_str = str_match(end);
    Grad_Comp     = str2double(Grad_Comp_str);
    if Grad_Comp > Geo_Dim
        error('Cannot use derivatives beyond the geometric dimension.');
    end
    Comp = [Basis_Comp, Grad_Comp];
    Replacement_str = Func_Coef_Replacement('Grad',obj.FuncTrans,Comp,coef_func_STR,Tuple_Comp_c_ind_STR);
    
% check if it is the divergence operator
elseif ~isempty(regexp(input_str,[var_str, MATCH_STR.div], 'once'))
    
    obj.Opt.Div = true;
    if (obj.Elem.Basis_Size(1) < 2)
        error('Can only use "div" operator on functions that are intrinsically vector-valued.');
    end
    Replacement_str = Func_Coef_Replacement('Div',obj.FuncTrans,Basis_Comp,coef_func_STR,Tuple_Comp_c_ind_STR);
    
% check if it is the vector curl operator
elseif ~isempty(regexp(input_str,[var_str, MATCH_STR.vector_curl], 'once'))
    
    obj.Opt.Curl = true;
    if (obj.Elem.Basis_Size(1) < 2)
        error('Can only use "curl" operator on functions that are intrinsically vector-valued.');
    end
    Replacement_str = Func_Coef_Replacement('Curl',obj.FuncTrans,Basis_Comp,coef_func_STR,Tuple_Comp_c_ind_STR);
    
% check if it is the scalar curl operator
elseif ~isempty(regexp(input_str,[var_str, MATCH_STR.scalar_curl], 'once'))
    
    obj.Opt.Curl = true;
    if (obj.Elem.Basis_Size(1) < 2)
        error('Can only use "curl" operator on functions that are intrinsically vector-valued.');
    end
    Replacement_str = Func_Coef_Replacement('Curl',obj.FuncTrans,Basis_Comp,coef_func_STR,Tuple_Comp_c_ind_STR);
    
% check if it is the 2nd arc-length derivative along a curve
elseif ~isempty(regexp(input_str,[var_str, MATCH_STR.dsds], 'once'))
    
    obj.Opt.d2_ds2 = true;
    if obj.Elem.Top_Dim > 1
        error('Cannot use 2nd arc-length derivative in topological dimensions greater than 1.');
    end
    Replacement_str = Func_Coef_Replacement('d2_ds2',obj.FuncTrans,Basis_Comp,coef_func_STR,Tuple_Comp_c_ind_STR);

% check if it is the 1st arc-length derivative along a curve
elseif ~isempty(regexp(input_str,[var_str, MATCH_STR.ds], 'once'))
    
    obj.Opt.d_ds = true;
    if obj.Elem.Top_Dim > 1
        error('Cannot use 1st arc-length derivative in topological dimensions greater than 1.');
    end
    Replacement_str = Func_Coef_Replacement('d_ds',obj.FuncTrans,Basis_Comp,coef_func_STR,Tuple_Comp_c_ind_STR);
    
% check if it is the value of the function
elseif ~isempty(regexp(input_str,[var_str, MATCH_STR.val], 'once'))
    
    obj.Opt.Val = true;
    Replacement_str = Func_Coef_Replacement('Val',obj.FuncTrans,Basis_Comp,coef_func_STR,Tuple_Comp_c_ind_STR);
    
else
    disp('There was no match for the coefficient function:');
    input_str
end

if ~isempty(Replacement_str)
    if or(isa(obj.FuncTrans,'Hdiv_Trans'),isa(obj.FuncTrans,'Hcurl_Trans'))
        % for H(div) and H(curl), we always need the orientation (of the "facets")
        obj.Opt.Orientation = true;
    end
end

end

function STR = Func_Coef_Replacement(FIELD_STR,FuncTrans,Comp,coef_func_STR,Tuple_Comp_STR)

CPP_Name        = FuncTrans.Output_CPP_Var_Name(FIELD_STR);
CPP_Name_w_CF   = [coef_func_STR, CPP_Name];

if isa(FuncTrans,'Constant_Trans') % special case for global CONSTANT coefficient functions
    STR_begin = [CPP_Name_w_CF, Tuple_Comp_STR];
else
    STR_begin = [CPP_Name_w_CF, Tuple_Comp_STR, '[qp]'];
end
Eval_Ext = FuncTrans.Output_CPP_Eval_Extension(FIELD_STR,Comp);
STR = [STR_begin, Eval_Ext];

end