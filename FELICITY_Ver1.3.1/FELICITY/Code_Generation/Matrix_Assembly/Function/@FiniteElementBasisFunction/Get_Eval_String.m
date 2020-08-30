function [obj, Replacement_str] = Get_Eval_String(obj,input_str,var_str,Geo_Dim,Num_Tuple_in_FE_Space)
%Get_Eval_String
%
%   This will parse the basis function string.  It also sets the options
%   (.Opt) of the function.

% Copyright (c) 12-15-2017,  Shawn W. Walker

% init
Replacement_str = [];
len_var_str = length(var_str);

CONST = strcmp(obj.Type,'CONST'); % is the basis function the constant 1
if ~CONST
    %%%%
    
    if length(input_str) < (len_var_str+6)
        %     disp('Input argument string not long enough!');
        %     var_str
        return;
    end
    % make sure the *beginning of input_str* matches var_str!
    if ~strncmp(input_str,var_str,len_var_str)
        % if the variable name does not match what is in the input string,
        % then just exit (this isn't the right function anyway!)
        return;
    end
    
    % setup matching strings
    MATCH_STR = obj.Get_String_Match_Struct;
    
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
    
    [Basis_Comp, ~] = obj.Parse_Vector_Tensor_Components(input_str,var_str,Num_Tuple_in_FE_Space);
    
    basis_func_STR  = [obj.CPP_Var, '->'];
    if strcmp(obj.Type,'Test')
        basis_index_STR = '[i]'; % row index
    elseif strcmp(obj.Type,'Trial')
        basis_index_STR = '[j]'; % col index
    else
        error('Something is wrong!');
    end
    
    % check if it is the hessian of the function
    if ~isempty(regexp(input_str,[var_str, MATCH_STR.hess], 'once'))
        
        str_match_cell = regexp(input_str,[var_str, MATCH_STR.hess], 'match');
        str_match = str_match_cell{1};
        
        obj.Opt.Hess  = true;
        % parse the hessian components
        Hess_Comp_1_str = str_match(end-1);
        Hess_Comp_2_str = str_match(end);
        Hess_Comp       = [str2double(Hess_Comp_1_str), str2double(Hess_Comp_2_str)];
        if ( max(Hess_Comp) > Geo_Dim )
            error('Cannot use derivatives beyond the geometric dimension.');
        end
        Replacement_str = Func_Basis_Replacement('Hess',obj.FuncTrans,[Basis_Comp, Hess_Comp],...
                                                 basis_func_STR,basis_index_STR);

    % check if it is the gradient of the function
    elseif ~isempty(regexp(input_str,[var_str, MATCH_STR.grad], 'once'))
        
        str_match_cell = regexp(input_str,[var_str, MATCH_STR.grad], 'match');
        str_match = str_match_cell{1};
        
        obj.Opt.Grad  = true;
        % parse the gradient component
        Grad_Comp_str = str_match(end);
        Grad_Comp     = str2double(Grad_Comp_str);
        if Grad_Comp > Geo_Dim
            error('Cannot use derivatives beyond the geometric dimension.');
        end
        Replacement_str = Func_Basis_Replacement('Grad',obj.FuncTrans,[Basis_Comp, Grad_Comp],...
                                                 basis_func_STR,basis_index_STR);

    % check if it is the divergence operator
    elseif ~isempty(regexp(input_str,[var_str, MATCH_STR.div], 'once'))
        
        obj.Opt.Div = true;
        if (obj.Elem.Basis_Size(1) < 2)
            error('Can only use "div" operator on functions that are intrinsically vector-valued.');
        end
        Replacement_str = Func_Basis_Replacement('Div',obj.FuncTrans,Basis_Comp,...
                                                 basis_func_STR,basis_index_STR);
    
    % check if it is the vector curl operator
    elseif ~isempty(regexp(input_str,[var_str, MATCH_STR.vector_curl], 'once'))
        
        obj.Opt.Curl = true;
        if (obj.Elem.Basis_Size(1) < 2)
            error('Can only use "curl" operator on functions that are intrinsically vector-valued.');
        end
        Replacement_str = Func_Basis_Replacement('Curl',obj.FuncTrans,Basis_Comp,...
                                                 basis_func_STR,basis_index_STR);
    
    % check if it is the scalar curl operator
    elseif ~isempty(regexp(input_str,[var_str, MATCH_STR.scalar_curl], 'once'))
        
        obj.Opt.Curl = true;
        if (obj.Elem.Basis_Size(1) < 2)
            error('Can only use "curl" operator on functions that are intrinsically vector-valued.');
        end
        Replacement_str = Func_Basis_Replacement('Curl',obj.FuncTrans,Basis_Comp,...
                                                 basis_func_STR,basis_index_STR);
    
    % check if it is the 2nd arc-length derivative along a curve
    elseif ~isempty(regexp(input_str,[var_str, MATCH_STR.dsds], 'once'))
        
        obj.Opt.d2_ds2 = true;
        if obj.Elem.Top_Dim > 1
            error('Cannot use 2nd arc-length derivative in topological dimensions greater than 1.');
        end
        Replacement_str = Func_Basis_Replacement('d2_ds2',obj.FuncTrans,Basis_Comp,...
                                                 basis_func_STR,basis_index_STR);

    % check if it is the 1st arc-length derivative along a curve
    elseif ~isempty(regexp(input_str,[var_str, MATCH_STR.ds], 'once'))
        
        obj.Opt.d_ds = true;
        if obj.Elem.Top_Dim > 1
            error('Cannot use 1st arc-length derivative in topological dimensions greater than 1.');
        end
        Replacement_str = Func_Basis_Replacement('d_ds',obj.FuncTrans,Basis_Comp,...
                                                 basis_func_STR,basis_index_STR);

    % check if it is the value of the function
    elseif ~isempty(regexp(input_str,[var_str, MATCH_STR.val], 'once'))
        
        obj.Opt.Val = true;
        Replacement_str = Func_Val_Replacement(obj.FuncTrans,Basis_Comp,basis_func_STR,basis_index_STR);
        
    else
        % there was no match against a *basis* function;
        % but outside this routine, there may be a match to something else,
        % like a *coefficient* function or a geometric function.
        % so, no need to worry just yet.
        
        % if nothing identifies it, then an error message outside this will
        % catch it.
        %disp('There was no match for the basis function!');
        %input_str
    end
end

if ~isempty(Replacement_str)
    if or(isa(obj.FuncTrans,'Hdiv_Trans'),isa(obj.FuncTrans,'Hcurl_Trans'))
        % for H(div) and H(curl), we always need the orientation (of the "facets")
        obj.Opt.Orientation = true;
    end
end

end

function STR = Func_Basis_Replacement(FIELD_STR,FuncTrans,Components,basis_func_STR,basis_index_STR)

CPP_Name      = FuncTrans.Output_CPP_Var_Name(FIELD_STR);
CPP_Name_w_BF = [basis_func_STR, CPP_Name];

STR_begin = [CPP_Name_w_BF, basis_index_STR, '[qp]'];
Eval_Ext = FuncTrans.Output_CPP_Eval_Extension(FIELD_STR,Components);
STR = [STR_begin, Eval_Ext];

end

function STR = Func_Val_Replacement(FuncTrans,Basis_Comp,basis_func_STR,basis_index_STR)

CPP_Name        = FuncTrans.Output_CPP_Var_Name('Val');

if isa(FuncTrans,'H1_Trans') % special case for H^1 functions
    % note: we must de-reference here!!!!
    CPP_Name_w_BF = ['(*', basis_func_STR, CPP_Name, ')'];
else
    CPP_Name_w_BF = [basis_func_STR, CPP_Name];
end

if isa(FuncTrans,'Constant_Trans') % special case for global CONSTANT functions
    STR_begin = CPP_Name_w_BF;
else
    STR_begin = [CPP_Name_w_BF, basis_index_STR, '[qp]'];
end

Eval_Ext = FuncTrans.Output_CPP_Eval_Extension('Val',Basis_Comp);
STR = [STR_begin, Eval_Ext];

end