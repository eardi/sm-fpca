function CODE = PHI_Val_C_Code(obj,Num_Basis)
%PHI_Val_C_Code
%
%   Generate C-code for direct evaluation of PHI.
%            PHI_i(qp) = SUM^{Num_Basis}_{k=1} c_{ki} phi_k(qp),
%                        1 <= i <= GeoDim, and qp are the coordinates of
%                                              a quadrature point.

% Copyright (c) 08-17-2017,  Shawn W. Walker

% constants that multiply the basis functions
coefs = sym('coef_%d_%d_',[Num_Basis, obj.GeoDim]);
local_basis = sym('Geo_phi_%d_',[Num_Basis, 1]);

% make var string
CODE.Var_Name(1).line = []; % init
CODE.Var_Name(1).line = obj.Output_CPP_Var_Name('Val');

% loop thru all components of the map
EVAL_STR(obj.GeoDim).line = []; % init
for ig=1:obj.GeoDim
    RESULT = sum(coefs(:,ig) .* local_basis); % evaluate PHI_i(qp)
    TEMP_STR = ccode(RESULT); % turn into C-code!
    
    % make string replacements
    PHI_Val_str = obj.Get_CPP_Vector_Eval_String(CODE.Var_Name(1).line,ig);
    TEMP_STR = regexprep(TEMP_STR, '  t0', PHI_Val_str); % t0 is the default LHS term
    for ib=1:Num_Basis
        Geo_phi_S_str = ['Geo_phi_', num2str(ib), '_'];
        Geo_phi_C_str = ['Geo_Basis_Val_0_0_0[qp_i]', '[', num2str(ib-1), ']']; % C-style indexing
        TEMP_STR = regexprep(TEMP_STR, Geo_phi_S_str, Geo_phi_C_str);
        coef_S_str = ['coef_', num2str(ib), '_', num2str(ig), '_'];
        coef_C_str = ['Node_Value', '[', num2str(ig-1), ']', '[kc[', num2str(ib-1), ']]']; % C-style indexing
        TEMP_STR = regexprep(TEMP_STR, coef_S_str, coef_C_str);
    end
    EVAL_STR(ig).line = TEMP_STR;
end

% define the data type
TYPE_str = obj.Get_CPP_Vector_Data_Type_Name(obj.GeoDim);
Defn_Hdr = '// local map evaluated at a quadrature point in reference element';
Loop_Hdr = '// compute the local map\n    // note: indexing is in the C style';
Loop_Comment = '// sum over basis functions';
CONST_VAR = false; % the map is not constant, of course!
CODE = obj.create_declaration_and_eval_code(CODE.Var_Name,TYPE_str,EVAL_STR,...
                                            Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
%
end