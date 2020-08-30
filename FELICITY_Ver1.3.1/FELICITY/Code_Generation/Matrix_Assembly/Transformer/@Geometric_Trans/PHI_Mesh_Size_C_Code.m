function CODE = PHI_Mesh_Size_C_Code(obj,Num_Basis)
%PHI_Mesh_Size_C_Code
%
%   Generate C-code for computing the mesh size (with PHI).
%            vx_i(qp) = SUM^{Num_Basis}_{k=1} c_{ki} phi_k(\hat{vx}_i),
%                        1 <= i <= GeoDim, and \hat{vx}_i are the local
%                        coordinates of the reference element (simplex).

% Copyright (c) 08-17-2017,  Shawn W. Walker

% make var string
CODE.Var_Name(1).line = []; % init
CODE.Var_Name(1).line = obj.Output_CPP_Var_Name('Mesh_Size');

% loop thru all components of the map
Num_Corner_Vtx = obj.TopDim + 1;
EVAL_STR(obj.GeoDim*Num_Corner_Vtx + Num_Corner_Vtx + 2).line = []; % init
Vec_Data_Type_str = obj.Get_CPP_Vector_Data_Type_Name(obj.GeoDim);
INDEX = 0;
for cp=1:Num_Corner_Vtx
    INDEX = INDEX + 1;
    EVAL_STR(INDEX).line = [Vec_Data_Type_str, '  ', 'Pt', num2str(cp), ';'];
end
INDEX = INDEX + 1;
EVAL_STR(INDEX).line = '// compute vertex positions by summing over basis functions';
for ig=1:obj.GeoDim
    for cp=1:Num_Corner_Vtx
        INDEX = INDEX + 1;
        EVAL_STR(INDEX).line = gen_eval_code(obj,Num_Basis,ig,cp);
    end
end

% compute the mesh size
INDEX = INDEX + 1;
EVAL_STR(INDEX).line = '// compute the local mesh size';
Num1 = length(EVAL_STR);
if (obj.TopDim==1)
    EVAL_STR(Num1 + 1).line = [Vec_Data_Type_str, '  ', 'TEMP_Vec' ';'];
    EVAL_STR(Num1 + 2).line = ['Subtract_Vector(Pt2, Pt1, TEMP_Vec);'];
    EVAL_STR(Num1 + 3).line = [CODE.Var_Name(1).line, '[0].a', ' = l2_norm(TEMP_Vec);'];
elseif (obj.TopDim==2)
    EVAL_STR(Num1 +  1).line = [Vec_Data_Type_str, '  ', 'TEMP_Vec' ';'];
    EVAL_STR(Num1 +  2).line = ['double  MESH_H[3];'];
    EVAL_STR(Num1 +  3).line = ['Subtract_Vector(Pt2, Pt1, TEMP_Vec);'];
    EVAL_STR(Num1 +  4).line = ['MESH_H[0] = l2_norm(TEMP_Vec);'];
    EVAL_STR(Num1 +  5).line = ['Subtract_Vector(Pt3, Pt1, TEMP_Vec);'];
    EVAL_STR(Num1 +  6).line = ['MESH_H[1] = l2_norm(TEMP_Vec);'];
    EVAL_STR(Num1 +  7).line = ['Subtract_Vector(Pt3, Pt2, TEMP_Vec);'];
    EVAL_STR(Num1 +  8).line = ['MESH_H[2] = l2_norm(TEMP_Vec);'];
    EVAL_STR(Num1 +  9).line = [CODE.Var_Name(1).line, '[0].a', ' = *max_element(MESH_H, MESH_H+3); // longest edge'];
elseif (obj.TopDim==3)
    EVAL_STR(Num1 +  1).line = [Vec_Data_Type_str, '  ', 'TEMP_Vec' ';'];
    EVAL_STR(Num1 +  2).line = ['double  MESH_H[6];'];
    EVAL_STR(Num1 +  3).line = ['Subtract_Vector(Pt2, Pt1, TEMP_Vec);'];
    EVAL_STR(Num1 +  4).line = ['MESH_H[0] = l2_norm(TEMP_Vec);'];
    EVAL_STR(Num1 +  5).line = ['Subtract_Vector(Pt3, Pt1, TEMP_Vec);'];
    EVAL_STR(Num1 +  6).line = ['MESH_H[1] = l2_norm(TEMP_Vec);'];
    EVAL_STR(Num1 +  7).line = ['Subtract_Vector(Pt4, Pt1, TEMP_Vec);'];
    EVAL_STR(Num1 +  8).line = ['MESH_H[2] = l2_norm(TEMP_Vec);'];
    EVAL_STR(Num1 +  9).line = ['Subtract_Vector(Pt3, Pt2, TEMP_Vec);'];
    EVAL_STR(Num1 + 10).line = ['MESH_H[3] = l2_norm(TEMP_Vec);'];
    EVAL_STR(Num1 + 11).line = ['Subtract_Vector(Pt4, Pt3, TEMP_Vec);'];
    EVAL_STR(Num1 + 12).line = ['MESH_H[4] = l2_norm(TEMP_Vec);'];
    EVAL_STR(Num1 + 13).line = ['Subtract_Vector(Pt2, Pt4, TEMP_Vec);'];
    EVAL_STR(Num1 + 14).line = ['MESH_H[5] = l2_norm(TEMP_Vec);'];
    EVAL_STR(Num1 + 15).line = [CODE.Var_Name(1).line, '[0].a', ' = *max_element(MESH_H, MESH_H+6); // longest edge'];
else
    error('Invalid!');
end
EVAL_STR(end+1).line = '';

% define the data type
TYPE_str = obj.Get_CPP_Scalar_Data_Type_Name;
Defn_Hdr = '// local mesh size of reference element';
CONST_VAR = true; % the mesh size is constant over each element
CODE = special_declaration_and_eval_code(CODE.Var_Name,TYPE_str,EVAL_STR,...
                                         Defn_Hdr,CONST_VAR);
%
end

function STR = gen_eval_code(obj,Num_Basis,ig,cp)

% constants that multiply the basis functions
coefs = sym('coef_%d_%d_',[Num_Basis, obj.GeoDim]);
local_basis = sym('Geo_phi_%d_',[Num_Basis, 1]);

RESULT = sum(coefs(:,ig) .* local_basis); % evaluate PHI_i(qp)
TEMP_STR = ccode(RESULT); % turn into C-code!

% make string replacements
COORD_str_X = ['Pt', num2str(cp), '.v', '[', num2str(ig-1), ']'];
TEMP_STR = regexprep(TEMP_STR, '  t0', COORD_str_X); % t0 is the default LHS term
for ib=1:Num_Basis
    Geo_phi_S_str = ['Geo_phi_', num2str(ib), '_'];
    Geo_phi_C_str = ['Geo_Vtx_Basis_Val_0_0_0', '[', num2str(cp-1), ']', '[', num2str(ib-1), ']']; % C-style indexing
    TEMP_STR = regexprep(TEMP_STR, Geo_phi_S_str, Geo_phi_C_str);
    coef_S_str = ['coef_', num2str(ib), '_', num2str(ig), '_'];
    coef_C_str = ['Node_Value', '[', num2str(ig-1), ']', '[kc[', num2str(ib-1), ']]']; % C-style indexing
    TEMP_STR = regexprep(TEMP_STR, coef_S_str, coef_C_str);
end
STR = TEMP_STR;

end

function CODE = special_declaration_and_eval_code(Var_Str,TYPE_str,Eval_Str,...
                                                  Defn_Hdr,CONST_TF)

% create struct (init)
CODE.Var_Name  = Var_Str;
CODE.Constant  = CONST_TF; % is the variable a constant (does not vary over the quad points)
CODE.Defn      = [];
CODE.Eval_Snip = [];

% create declaration code
CODE.Defn(2).line = [];
CODE.Defn(1).line = Defn_Hdr;
CODE.Defn(2).line = [TYPE_str, ' ', CODE.Var_Name(1).line, '[1]', ';'];

% create evaluation code
num_eval = length(Eval_Str(:));
CODE.Eval_Snip(num_eval).line = [];
for ind=1:num_eval
    CODE.Eval_Snip(ind).line = [Eval_Str(ind).line];
end

end