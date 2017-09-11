function [I_Values, CV] = Image_Proc_Demo_Sample_ChanVese(P1_Mesh_Vtx, Image_Data, PARAM)
%Image_Proc_Demo_Sample_ChanVese
%
%   Demo for FELICITY - 2-D image processing with active contours.

% Copyright (c) 09-26-2011,  Shawn W. Walker

% sample Image on the 1-D curve
I_Values = interp2(Image_Data.X_grid,Image_Data.Y_grid,Image_Data.I,P1_Mesh_Vtx(:,1),P1_Mesh_Vtx(:,2),'*linear');

% compute Chan-Vese term
CV = (I_Values - PARAM.Cin).^2 - (I_Values - PARAM.Cout).^2;

end