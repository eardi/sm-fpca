function [P1_Mesh_Vtx_NEW, V_vec, END_OPT, PARAM] = Image_Proc_Demo_Optimization_Step(P1_Mesh_DoFmap, P1_Mesh_Vtx, Image_Data, PARAM)
%Image_Proc_Demo_Optimization_Step
%
%   Demo for FELICITY - 2-D image processing with active contours.

% Copyright (c) 09-26-2011,  Shawn W. Walker

% sample Chan-Vese term on the 1-D curve
[I_Values, CV] = Image_Proc_Demo_Sample_ChanVese(P1_Mesh_Vtx, Image_Data, PARAM);

% assemble matrices
FEM = DEMO_mex_Image_Proc_assemble([],P1_Mesh_Vtx,P1_Mesh_DoFmap,[],[],P1_Mesh_DoFmap,P1_Mesh_DoFmap,CV);
%       OUTPUTS (in consecutive order) 
%       ---------------------------------------- 
%       Curv_Vector 
%       F_Normal_Vector 
%       Mass_Matrix 
%       Stiff_Matrix 

% compute \delta J (i.e. shape derivative of Chan-Vese functional)
delta_J = PARAM.mu * FEM(1).MAT + FEM(2).MAT;

% BEGIN: solve for a descent direction

% assemble "inner product"
A = PARAM.W_L2 * FEM(3).MAT + PARAM.W_H1 * FEM(4).MAT;
% solve variational problem for descent (search) direction
% i.e. solve optimality condition for modified cost function with minimizing
% movements
SEARCH = A \ (-delta_J);
% rearrange SEARCH to be a sampled 2-D vector
V_vec = 0*P1_Mesh_Vtx;
V_vec(:) = SEARCH;

% END: solve for a descent direction

%L2_Norm = sqrt(V_vec(:)' * FEM(1).MAT * V_vec(:))

% line search to obtain new curve
[P1_Mesh_Vtx_NEW, END_OPT] = Image_Proc_Demo_LineSearch(P1_Mesh_DoFmap, P1_Mesh_Vtx, Image_Data, V_vec, PARAM);

% update Cin, Cout:
% sample image
CURVE_VTX = [[P1_Mesh_Vtx(:,1); P1_Mesh_Vtx(1,1)],[P1_Mesh_Vtx(:,2); P1_Mesh_Vtx(1,2)]];
IN = Image_Proc_Demo_inpoly([Image_Data.X_grid(:),Image_Data.Y_grid(:)],CURVE_VTX);
I_Vec = Image_Data.I(:);
I_inside  = I_Vec(IN);
I_outside = I_Vec(~IN);

% solve Euler-Lagrange for Cin, Cout:
% integrate (crude method)
PARAM.Cin  = Image_Data.dx * Image_Data.dy * full(sum(I_inside)) / (Image_Data.dx * Image_Data.dy * full(sum(IN)));
PARAM.Cout = Image_Data.dx * Image_Data.dy * full(sum(I_outside)) / (Image_Data.dx * Image_Data.dy * full(sum(~IN)));

end