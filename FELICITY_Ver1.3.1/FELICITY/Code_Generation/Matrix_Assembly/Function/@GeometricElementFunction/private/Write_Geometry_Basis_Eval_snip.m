function status = Write_Geometry_Basis_Eval_snip(obj,fid,Largest_Derivative_Order,Compute_Map)
%Write_Geometry_Basis_Eval_snip
%
%   This generates the code that holds the basis function evaluations and
%   quadrature rule for the local element geometry computation.

% Copyright (c) 09-14-2016,  Shawn W. Walker

% EXAMPLE:
% %%%%%%%
% /*------------ BEGIN: Auto Generate ------------*/
% // Local Map when TopDim = 1, GeoDim = 3, with P2 Lagrange Map
% // Number of Quadrature Points = 12
% 
% // Value of basis functions at quadrature points.
% static const double Geo_Basis_Val[NQ][NB] = { \
%   { 9.725109564747709e-001,  -9.049677771948640e-003,   3.653872129717781e-002}, \
%   { 8.607726348186749e-001,  -4.334462155179993e-002,   1.825719867331249e-001}, \
%   { 6.813264009629234e-001,  -8.857627323138148e-002,   4.072498722684582e-001}, \
%   { 4.661301668570177e-001,  -1.211877874296001e-001,   6.550576205725824e-001}, \
%   { 2.515657553267140e-001,  -1.162657436714659e-001,   8.646999883447519e-001}, \
%   { 7.045840755943468e-002,  -5.477500095203423e-002,   9.843165933925995e-001}, \
%   {-5.477500095203419e-002,   7.045840755943461e-002,   9.843165933925996e-001}, \
%   {-1.162657436714660e-001,   2.515657553267143e-001,   8.646999883447517e-001}, \
%   {-1.211877874296001e-001,   4.661301668570173e-001,   6.550576205725829e-001}, \
%   {-8.857627323138145e-002,   6.813264009629235e-001,   4.072498722684580e-001}, \
%   {-4.334462155179993e-002,   8.607726348186749e-001,   1.825719867331249e-001}, \
%   {-9.049677771948801e-003,   9.725109564747704e-001,   3.653872129717847e-002}};
% 
% // Value of (d/dx) basis functions at quadrature points.
% static const double Geo_Basis_Val_d_dx[NQ][NB] = { \
%   {-2.963121268493439e+000,  -9.631212684934389e-001,   3.926242536986878e+000}, \
%   {-2.808234512740950e+000,  -8.082345127409498e-001,   3.616469025481900e+000}, \
%   {-2.539805348388610e+000,  -5.398053483886096e-001,   3.079610696777219e+000}, \
%   {-2.174635908573236e+000,  -1.746359085732354e-001,   2.349271817146471e+000}, \
%   {-1.735662997996360e+000,   2.643370020036402e-001,   1.471325995992720e+000}, \
%   {-1.250466817022938e+000,   7.495331829770622e-001,   5.009336340458757e-001}, \
%   {-7.495331829770624e-001,   1.250466817022938e+000,  -5.009336340458752e-001}, \
%   {-2.643370020036393e-001,   1.735662997996361e+000,  -1.471325995992721e+000}, \
%   { 1.746359085732347e-001,   2.174635908573235e+000,  -2.349271817146470e+000}, \
%   { 5.398053483886098e-001,   2.539805348388610e+000,  -3.079610696777220e+000}, \
%   { 8.082345127409498e-001,   2.808234512740950e+000,  -3.616469025481900e+000}, \
%   { 9.631212684934383e-001,   2.963121268493438e+000,  -3.926242536986877e+000}};
% 
% // // set of quadrature points used
% // static const double Quad_Points[NQ][TD] = { \
% //     9.219682876640267e-003, \
% //     4.794137181476255e-002, \
% //     1.150486629028476e-001, \
% //     2.063410228566912e-001, \
% //     3.160842505009101e-001, \
% //     4.373832957442655e-001, \
% //     5.626167042557344e-001, \
% //     6.839157494990902e-001, \
% //     7.936589771433087e-001, \
% //     8.849513370971525e-001, \
% //     9.520586281852375e-001, \
% //     9.907803171233596e-001};
% 
% // set of quadrature weights
% static const double Quad_Weights[NQ] = { \
%     2.358766819325577e-002, \
%     5.346966299765937e-002, \
%     8.003916427167304e-002, \
%     1.015837133615329e-001, \
%     1.167462682691773e-001, \
%     1.245735229067018e-001, \
%     1.245735229067015e-001, \
%     1.167462682691769e-001, \
%     1.015837133615330e-001, \
%     8.003916427167301e-002, \
%     5.346966299765929e-002, \
%     2.358766819325577e-002};
% 
% /*------------   END: Auto Generate ------------*/

% get bogus quadrature rule on the ref elem
Quad_NOT_USED = obj.Elem.Gen_Quadrature_Rule(1, obj.Elem.Simplex_Type);
% get basis functions on reference element
Eval_Basis = obj.Elem.Gen_Basis_Function_Evals(Quad_NOT_USED.Pt,Largest_Derivative_Order);

% map geometric basis functions onto local mesh entity
CDMap = Codim_Map(obj);
Eval_Basis = CDMap.Map_Geometric_Basis_Function_Evals(Eval_Basis,Compute_Map.Codim_Map);

% get the quadrature rule on the local mesh entity
Quad = obj.Elem.Gen_Quadrature_Rule(Compute_Map.Num_Quad, Compute_Map.Integration_Simplex_Type);
for bb = 1:length(Eval_Basis)
    % evaluate all of the basis functions (and their derivatives) at the quad
    % points (on the local mesh entity)
    Eval_Basis(bb) = Eval_Basis(bb).Fill_Eval(Quad.Pt);
end

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
Num_Quad = size(Quad.Pt,1);
fprintf(fid, ['// Number of Quadrature Points = ', num2str(Num_Quad), ENDL]);
fprintf(fid, ['', ENDL]);

% write out the geometry basis function evaluations
status = obj.Generic_Write_Basis_Eval_to_CPP_Code_OLD('Geo','NQ','NB',Eval_Basis,[1 1],Largest_Derivative_Order,fid,'');

% NEXT, quad points
COMMENT = '// ';
status = obj.Gen_Quad_Point_CPP_Code(Quad.Pt,fid,COMMENT,'GLOBAL_TD');

% FINALLY, quad weights
COMMENT = '';
status = obj.Gen_Quad_Weight_CPP_Code(Quad.Wt,fid,COMMENT);

fprintf(fid, [obj.END_Auto_Gen, ENDL]);

end