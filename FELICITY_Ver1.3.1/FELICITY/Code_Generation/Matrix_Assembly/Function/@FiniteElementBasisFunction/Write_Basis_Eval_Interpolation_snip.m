function status = Write_Basis_Eval_Interpolation_snip(obj,fid,Largest_Derivative_Order,Map_Basis)
%Write_Basis_Eval_Interpolation_snip
%
%   This generates the code that holds the basis function evaluations and
%   quadrature rule for the local external function computations.

% Copyright (c) 10-28-2016,  Shawn W. Walker

% EXAMPLE:
% %%%%%%%
% /*------------ BEGIN: Auto Generate ------------*/
% // Local Element defined on Subdomain: CG, lagrange_deg2_dim2
% // the Subdomain             has topological dimension = 2
% // the Domain of Integration has topological dimension = 2
% // geometric dimension = 2
% 
%     // convenience variables
%     const double& x_hat = local_coord[0];
%     const double& y_hat = local_coord[1];
%     const double& z_hat = local_coord[2];
% /*------------   END: Auto Generate ------------*/

ENDL = '\n';
% output text-lines
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
MAP_POLY_TYPE_str = [obj.Elem.Element_Type, ', ', num2str(obj.Elem.Element_Name)];
fprintf(fid, ['// Local Element defined on Subdomain: ', MAP_POLY_TYPE_str, ENDL]);
fprintf(fid, ['// the Subdomain             has topological dimension = ', num2str(obj.GeomFunc.Domain.Subdomain.Top_Dim), ENDL]);
fprintf(fid, ['// the Domain of Integration has topological dimension = ', num2str(obj.GeomFunc.Domain.Integration_Domain.Top_Dim), ENDL]);
fprintf(fid, ['// geometric dimension = ', num2str(obj.GeomFunc.Domain.Integration_Domain.GeoDim), ENDL]);
fprintf(fid, ['', ENDL]);

% write variable declarations for holding basis function evaluations
status = obj.Basis_Eval_Variable_CPP_Declaration([],'NB',fid,'');

fprintf(fid, ['    ', '// convenience variables', ENDL]);
fprintf(fid, ['    ', 'const double& x_hat = local_coord[0];', ENDL]);
fprintf(fid, ['    ', 'const double& y_hat = local_coord[1];', ENDL]);
fprintf(fid, ['    ', 'const double& z_hat = local_coord[2];', ENDL]);
fprintf(fid, ['', ENDL]);

% must do special case for H(curl) in 3-D
HCURL_3D = and(isa(obj.FuncTrans,'Hcurl_Trans'),obj.Get_Top_Dim==3);
if HCURL_3D
    status = obj.Write_Basis_Eval_Interpolation_3D_Hcurl_snip(fid,Largest_Derivative_Order,Map_Basis);
else
    % do standard basis function mapping
    
    % get basis functions on reference element
    Quad_NOT_USED = obj.Elem.Gen_Quadrature_Rule(1, obj.Elem.Simplex_Type); % bogus! not really used
    Eval_Basis = obj.Elem.Gen_Basis_Function_Evals(Quad_NOT_USED.Pt,Largest_Derivative_Order);
    
    for bb = 1:length(Eval_Basis)
        % compose basis functions (and their derivatives) with Codim Map,
        % i.e. we are plugging in the map after differentiating.
        Eval_Basis(bb) = Eval_Basis(bb).Compose_With_Function(Map_Basis.Codim_Map);
    end
    
    % write out the FE basis function evaluations (at interpolation points)
    status = obj.Generic_Write_Basis_Eval_Interpolation_to_CPP_Code(fid,Eval_Basis,'');
end

fprintf(fid, [obj.END_Auto_Gen, ENDL]);

end