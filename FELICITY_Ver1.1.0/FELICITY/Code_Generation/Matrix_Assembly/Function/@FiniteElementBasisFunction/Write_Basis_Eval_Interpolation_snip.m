function status = Write_Basis_Eval_Interpolation_snip(obj,fid,HDR_str,Num_Deriv,Map_Basis)
%Write_Basis_Func_Eval_snip
%
%   This generates the code that holds the basis function evaluations and
%   quadrature rule for the local external function computations.

% Copyright (c) 04-07-2010,  Shawn W. Walker

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
% 
%     // Value of basis function, derivatives = [0  0  0], at local coordinates
%     double phi_0_Basis_Val_0_0_0[1][NB];
%       phi_0_Basis_Val_0_0_0[0][0] = (x_hat*2.0+y_hat*2.0-1.0)*(x_hat+y_hat-1.0);
%       phi_0_Basis_Val_0_0_0[0][1] = x_hat*(x_hat*2.0-1.0);
%       phi_0_Basis_Val_0_0_0[0][2] = y_hat*(y_hat*2.0-1.0);
%       phi_0_Basis_Val_0_0_0[0][3] = x_hat*y_hat*4.0;
%       phi_0_Basis_Val_0_0_0[0][4] = y_hat*(x_hat+y_hat-1.0)*-4.0;
%       phi_0_Basis_Val_0_0_0[0][5] = x_hat*(x_hat+y_hat-1.0)*-4.0;
% 
%     // Value of basis function, derivatives = [0  1  0], at local coordinates
%     double phi_0_Basis_Val_0_1_0[1][NB];
%       phi_0_Basis_Val_0_1_0[0][0] = x_hat*4.0+y_hat*4.0-3.0;
%       phi_0_Basis_Val_0_1_0[0][1] = 0.0;
%       phi_0_Basis_Val_0_1_0[0][2] = y_hat*4.0-1.0;
%       phi_0_Basis_Val_0_1_0[0][3] = x_hat*4.0;
%       phi_0_Basis_Val_0_1_0[0][4] = x_hat*-4.0-y_hat*8.0+4.0;
%       phi_0_Basis_Val_0_1_0[0][5] = x_hat*-4.0;
% 
%     // Value of basis function, derivatives = [1  0  0], at local coordinates
%     double phi_0_Basis_Val_1_0_0[1][NB];
%       phi_0_Basis_Val_1_0_0[0][0] = x_hat*4.0+y_hat*4.0-3.0;
%       phi_0_Basis_Val_1_0_0[0][1] = x_hat*4.0-1.0;
%       phi_0_Basis_Val_1_0_0[0][2] = 0.0;
%       phi_0_Basis_Val_1_0_0[0][3] = y_hat*4.0;
%       phi_0_Basis_Val_1_0_0[0][4] = y_hat*-4.0;
%       phi_0_Basis_Val_1_0_0[0][5] = x_hat*-8.0-y_hat*4.0+4.0;
% 
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

fprintf(fid, ['    ', '// convenience variables', ENDL]);
fprintf(fid, ['    ', 'const double& x_hat = local_coord[0];', ENDL]);
fprintf(fid, ['    ', 'const double& y_hat = local_coord[1];', ENDL]);
fprintf(fid, ['    ', 'const double& z_hat = local_coord[2];', ENDL]);
fprintf(fid, ['', ENDL]);

% get bogus quadrature rule on the ref elem
Quad_NOT_USED = obj.Elem.Gen_Quadrature_Rule(1, obj.Elem.Simplex_Type);
% get basis functions on reference element
Eval_Basis = obj.Elem.Gen_Basis_Function_Evals(Quad_NOT_USED.Pt,Num_Deriv);

for bb = 1:length(Eval_Basis)
    % compose basis functions (and their derivatives) with Codim Map,
    % i.e. we are plugging in the map after differentiating.
    Eval_Basis(bb) = Eval_Basis(bb).Compose_With_Function(Map_Basis.Codim_Map);
end

% write out the FE basis function evaluations (loop through all the components)
Deriv_Order = get_derivative_orders(Num_Deriv);
for vi = 1:obj.Elem.Num_Vec_Comp
    CPP_Name_Hdr = [HDR_str, '_', num2str(vi - 1)]; % basis function name (for given tensor component)
    Tensor_Comp = [vi, 1];
    
    status = obj.Generic_Write_Basis_Eval_Interpolation_to_CPP_Code(...
                 CPP_Name_Hdr,'NB',Deriv_Order,Tensor_Comp,Eval_Basis,fid,'');
end

fprintf(fid, [obj.END_Auto_Gen, ENDL]);

end

function Deriv_Order = get_derivative_orders(Num_Deriv)

if (Num_Deriv > 2)
    error('Not implemented!');
end

% choose the derivatives that are needed
Deriv_Order = (0:1:Num_Deriv)';

end