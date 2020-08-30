function status = Write_Geometry_Basis_Eval_Interpolation_snip(obj,fid,Largest_Derivative_Order,Compute_Map)
%Write_Geometry_Basis_Eval_Interpolation_snip
%
%   This generates the code that holds the basis function evaluations (at a
%   given local coordinate) for the local element geometry computation.

% Copyright (c) 09-14-2016,  Shawn W. Walker

% EXAMPLE:
% %%%%%%%
% /*------------ BEGIN: Auto Generate ------------*/
% // Intrinsic Map
% // Local Map Element on Global mesh: CG, lagrange_deg1_dim2
% // the Global mesh           has topological dimension = 2
% // the Subdomain             has topological dimension = 2
% // the Domain of Integration has topological dimension = 2
% // Map has geometric dimension = 2
% 
%     // convenience variables
%     const double& x_hat = local_coord[0];
%     const double& y_hat = local_coord[1];
%     const double& z_hat = local_coord[2];
% 
%     // Value of basis function, derivatives = [0  0  0], at local coordinates
%     double Geo_Basis_Val_0_0_0[1][NB];
%       Geo_Basis_Val_0_0_0[0][0] = -x_hat-y_hat+1.0;
%       Geo_Basis_Val_0_0_0[0][1] = x_hat;
%       Geo_Basis_Val_0_0_0[0][2] = y_hat;
% 
%     // Value of basis function, derivatives = [0  1  0], at local coordinates
%     double Geo_Basis_Val_0_1_0[1][NB];
%       Geo_Basis_Val_0_1_0[0][0] = -1.0;
%       Geo_Basis_Val_0_1_0[0][1] = 0.0;
%       Geo_Basis_Val_0_1_0[0][2] = 1.0;
% 
%     // Value of basis function, derivatives = [1  0  0], at local coordinates
%     double Geo_Basis_Val_1_0_0[1][NB];
%       Geo_Basis_Val_1_0_0[0][0] = -1.0;
%       Geo_Basis_Val_1_0_0[0][1] = 1.0;
%       Geo_Basis_Val_1_0_0[0][2] = 0.0;
% 
% /*------------   END: Auto Generate ------------*/

ENDL = '\n';
% output text-lines
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
INTRINSIC_TF = (obj.Domain.Subdomain.Top_Dim==obj.Domain.Integration_Domain.Top_Dim);
if INTRINSIC_TF
    fprintf(fid, ['// Intrinsic Map', ENDL]);
else
    fprintf(fid, ['// Restriction Map', ENDL]);
end
MAP_POLY_TYPE_str = [obj.Elem.Element_Type, ', ', num2str(obj.Elem.Element_Name)];
fprintf(fid, ['// Local Map Element on Global mesh: ', MAP_POLY_TYPE_str, ENDL]);
fprintf(fid, ['// the Global mesh           has topological dimension = ', num2str(obj.Domain.Global.Top_Dim), ENDL]);
fprintf(fid, ['// the Subdomain             has topological dimension = ', num2str(obj.Domain.Subdomain.Top_Dim), ENDL]);
fprintf(fid, ['// the Domain of Integration has topological dimension = ', num2str(obj.Domain.Integration_Domain.Top_Dim), ENDL]);
fprintf(fid, ['// Map has geometric dimension = ', num2str(obj.Domain.Integration_Domain.GeoDim), ENDL]);
fprintf(fid, ['', ENDL]);

fprintf(fid, ['    ', '// convenience variables', ENDL]);
fprintf(fid, ['    ', 'const double& x_hat = local_coord[0];', ENDL]);
fprintf(fid, ['    ', 'const double& y_hat = local_coord[1];', ENDL]);
fprintf(fid, ['    ', 'const double& z_hat = local_coord[2];', ENDL]);
fprintf(fid, ['', ENDL]);

% get bogus quadrature rule on the ref elem
Quad_NOT_USED = obj.Elem.Gen_Quadrature_Rule(1, obj.Elem.Simplex_Type);
% get basis functions on reference element
Eval_Basis = obj.Elem.Gen_Basis_Function_Evals(Quad_NOT_USED.Pt,Largest_Derivative_Order);

% map geometric basis functions onto local mesh entity
CDMap = Codim_Map(obj);
Eval_Basis = CDMap.Map_Geometric_Basis_Function_Evals(Eval_Basis,Compute_Map.Codim_Map);

% write out the geometry basis function evaluations
status = obj.Generic_Write_Basis_Eval_Interpolation_to_CPP_Code_OLD('Geo','NB',Largest_Derivative_Order,[1 1],Eval_Basis,fid,'');

fprintf(fid, [obj.END_Auto_Gen, ENDL]);

end