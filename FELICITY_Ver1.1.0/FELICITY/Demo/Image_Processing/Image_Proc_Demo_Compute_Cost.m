function Cost = Image_Proc_Demo_Compute_Cost(P1_Mesh_DoFmap, P1_Mesh_Vtx, Image_Data, PARAM)
%Image_Proc_Demo_Compute_Cost
%
%   Demo for FELICITY - 2-D image processing with active contours.

% Copyright (c) 09-26-2011,  Shawn W. Walker

% sample Image values on the curve
I_Values = Image_Proc_Demo_Sample_ChanVese(P1_Mesh_Vtx, Image_Data, PARAM);

BAD_CURVE = (max(isnan(I_Values))==1);
if BAD_CURVE
    %disp('There is a NaN!');
    Cost = inf;
    return;
end

% can pass dummy F values
% only need the mass and stiffness matrices
FEM = DEMO_mex_Image_Proc_assemble([],P1_Mesh_Vtx,P1_Mesh_DoFmap,[],[],P1_Mesh_DoFmap,P1_Mesh_DoFmap,0*I_Values);

% Chan-Vese cost
CURVE_VTX = [[P1_Mesh_Vtx(:,1); P1_Mesh_Vtx(1,1)],[P1_Mesh_Vtx(:,2); P1_Mesh_Vtx(1,2)]];
IN = Image_Proc_Demo_inpoly([Image_Data.X_grid(:),Image_Data.Y_grid(:)],CURVE_VTX);
I_Vec = Image_Data.I(:);
I_inside  = I_Vec(IN);
I_outside = I_Vec(~IN);

% integrate (crude method)
Jin  = Image_Data.dx * Image_Data.dy * full(sum((I_inside  - PARAM.Cin).^2));
Jout = Image_Data.dx * Image_Data.dy * full(sum((I_outside - PARAM.Cout).^2));

LENGTH = full(sum(FEM(3).MAT(:)));
Cost = (PARAM.mu * LENGTH) + Jin + Jout;

% % % now compute total cost, i.e. with minimizing movement penalty
% % A = PARAM.W_L2 * FEM(3).MAT + PARAM.W_H1 * FEM(4).MAT; % inner product
% % Movement_Cost = (step_size/2) * (V_vec(:)' * A * V_vec(:)); % quadratic penalty term

end