function status = Write_Basis_Func_Eval_snip(obj,fid,Largest_Derivative_Order,Map_Basis)
%Write_Basis_Func_Eval_snip
%
%   This generates the code that holds the basis function evaluations and
%   quadrature rule for the local external function computations.

% Copyright (c) 10-28-2016,  Shawn W. Walker

% get the "real" quadrature rule on the *local mesh entity*
Quad = obj.Elem.Gen_Quadrature_Rule(Map_Basis.Num_Quad, Map_Basis.Integration_Simplex_Type);

ENDL = '\n';
% output header text-lines
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
MAP_POLY_TYPE_str = [obj.Elem.Element_Type, ', ', obj.Elem.Element_Name];
fprintf(fid, ['// Local Element defined on Subdomain: ', MAP_POLY_TYPE_str, ENDL]);
fprintf(fid, ['// the Subdomain             has topological dimension = ', num2str(obj.GeomFunc.Domain.Subdomain.Top_Dim), ENDL]);
fprintf(fid, ['// the Domain of Integration has topological dimension = ', num2str(obj.GeomFunc.Domain.Integration_Domain.Top_Dim), ENDL]);
fprintf(fid, ['// geometric dimension = ', num2str(obj.GeomFunc.Domain.Integration_Domain.GeoDim), ENDL]);
fprintf(fid, ['// Number of Quadrature Points = ', num2str(size(Quad.Pt,1)), ENDL]);
fprintf(fid, ['', ENDL]);

% write variable declarations for holding basis function evaluations
status = obj.Basis_Eval_Variable_CPP_Declaration('NQ','NB',fid,'');

% must do special case for H(curl) in 3-D
HCURL_3D = and(isa(obj.FuncTrans,'Hcurl_Trans'),obj.Get_Top_Dim==3);
if HCURL_3D
    status = obj.Write_Basis_Func_Eval_3D_Hcurl_snip(fid,Largest_Derivative_Order,Map_Basis,Quad);
else
    % do standard element
    
    % get basis functions on reference element
    Quad_NOT_USED = obj.Elem.Gen_Quadrature_Rule(1, obj.Elem.Simplex_Type); % bogus! not really used
    Eval_Basis = obj.Elem.Gen_Basis_Function_Evals(Quad_NOT_USED.Pt,Largest_Derivative_Order);
    
    % map all basis functions
    for bb = 1:length(Eval_Basis)
        % compose basis functions (and their derivatives) with Codim Map,
        % i.e. we are plugging in the map after differentiating.
        Eval_Basis(bb) = Eval_Basis(bb).Compose_With_Function(Map_Basis.Codim_Map);
    end
    
    % write out the finite element function basis evaluations
    status = obj.Generic_Write_Basis_Eval_to_CPP_Code(Quad.Pt,fid,Eval_Basis,'');
end

% NEXT, quad points
COMMENT = '// ';
status = obj.Gen_Quad_Point_CPP_Code(Quad.Pt,fid,COMMENT,'SUB_TD');

% FINALLY, quad weights
fprintf(fid, ['', ENDL]);
COMMENT = '// ';
status = obj.Gen_Quad_Weight_CPP_Code(Quad.Wt,fid,COMMENT);

fprintf(fid, [obj.END_Auto_Gen, ENDL]);

end