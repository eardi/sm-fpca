function status = Write_Basis_Func_Eval_3D_Hcurl_snip(obj,fid,Largest_Derivative_Order,Map_Basis,Quad)
%Write_Basis_Func_Eval_3D_Hcurl_snip
%
%   This does part of the job of "Write_Basis_Func_Eval_snip" except for
%   H(curl) elements in 3-D (because they are a PITA).

% Copyright (c) 11-08-2016,  Shawn W. Walker

% load mirror image basis set
FuncName = [obj.Elem.Element_Name, '_mirror_image();'];
Mirror_Elem = eval(FuncName);

% put into a better object
Mirror_RefElem = ReferenceFiniteElement(Mirror_Elem);

% get basis functions on reference element
Quad_NOT_USED = obj.Elem.Gen_Quadrature_Rule(1, obj.Elem.Simplex_Type); % bogus! not really used
Eval_Basis = obj.Elem.Gen_Basis_Function_Evals(Quad_NOT_USED.Pt,Largest_Derivative_Order);
Eval_Basis_Mirror = Mirror_RefElem.Gen_Basis_Function_Evals(Quad_NOT_USED.Pt,Largest_Derivative_Order);

ENDL = '\n';
TAB = '    ';
TAB2 = [TAB, TAB];
TAB3 = [TAB, TAB, TAB];

% begin massive switch statement
fprintf(fid, [TAB, '// choose basis evaluations based on element order', ENDL]);
fprintf(fid, [TAB, 'if (Std_Elem_Order) // V_1 < V_2 < V_3 < V_4', ENDL]);
fprintf(fid, [TAB2, '{', ENDL]);
disp(['##write basis evals for ascending order.']);

status = write_basis_set(obj,fid,Eval_Basis,Map_Basis,Quad,TAB);

fprintf(fid, [TAB2, '}', ENDL]);
fprintf(fid, [TAB, 'else // V_1 < V_3 < V_2 < V_4', ENDL]);
fprintf(fid, [TAB2, '{', ENDL]);
disp(['##write basis evals for mirror image ascending order.']);

status = write_basis_set(obj,fid,Eval_Basis_Mirror,Map_Basis,Quad,TAB);

fprintf(fid, [TAB2, '}', ENDL]);
fprintf(fid, [TAB, '// END: choose basis evaluations based on element order', ENDL]);

end

function status = write_basis_set(obj,fid,Eval_Basis,Map_Basis,Quad,TAB)

% map all basis functions
for bb = 1:length(Eval_Basis)
    % compose basis functions (and their derivatives) with Codim Map,
    % i.e. we are plugging in the map after differentiating.
    Eval_Basis(bb) = Eval_Basis(bb).Compose_With_Function(Map_Basis.Codim_Map);
end

% write out the finite element function basis evaluations
status = obj.Generic_Write_Basis_Eval_to_CPP_Code(Quad.Pt,fid,Eval_Basis,TAB);

end