% test_geo_transformer_code
%
% unofficial test code
clc;
clear all classes;

LIN_MAP_TF = true;
% for ii=1:3
%     for jj=ii:3
gd = jj;
td = ii;
MAP1 = Geometric_Trans('test',gd,td,LIN_MAP_TF);
MAP1.PHI

NB = 3;
PHI_Mesh_Size_CC               = MAP1.PHI_Mesh_Size_C_Code(NB);
PHI_Val_CC                     = MAP1.PHI_Val_C_Code(NB);
PHI_Grad_CC                    = MAP1.PHI_Grad_C_Code(NB);
PHI_Metric_CC                  = MAP1.PHI_Metric_C_Code;
PHI_Det_Metric_CC              = MAP1.PHI_Det_Metric_C_Code;
PHI_Inv_Det_Metric_CC          = MAP1.PHI_Inv_Det_Metric_C_Code;
PHI_Inv_Metric_CC              = MAP1.PHI_Inv_Metric_C_Code;
PHI_Det_Jac_CC                 = MAP1.PHI_Det_Jac_C_Code;
PHI_Det_Jac_w_Weight_CC        = MAP1.PHI_Det_Jac_w_Weight_C_Code;
PHI_Inv_Det_Jac_CC             = MAP1.PHI_Inv_Det_Jac_C_Code;
PHI_Inv_Grad_CC                = MAP1.PHI_Inv_Grad_C_Code;
PHI_Tangent_Vector_CC          = MAP1.PHI_Tangent_Vector_C_Code;
PHI_Normal_Vector_CC           = MAP1.PHI_Normal_Vector_C_Code;
PHI_Tan_Space_Proj_CC          = MAP1.PHI_Tan_Space_Proj_C_Code;
PHI_Hess_CC                    = MAP1.PHI_Hess_C_Code(NB);
PHI_2nd_Fund_Form_CC           = MAP1.PHI_2nd_Fund_Form_C_Code;
PHI_Det_2nd_Fund_Form_CC       = MAP1.PHI_Det_2nd_Fund_Form_C_Code;
PHI_Inv_Det_2nd_Fund_Form_CC   = MAP1.PHI_Inv_Det_2nd_Fund_Form_C_Code;
PHI_Total_Curvature_Vector_CC  = MAP1.PHI_Total_Curvature_Vector_C_Code;
PHI_Total_Curvature_CC         = MAP1.PHI_Total_Curvature_C_Code;
PHI_Gauss_Curvature_CC         = MAP1.PHI_Gauss_Curvature_C_Code;

% %%%%%%%
% MAP1.Write_C_Code_To_File('C:\TEMP\codes\PHI_Mesh_Size_CC.cc',PHI_Mesh_Size_CC);
% MAP1.Write_C_Code_To_File('C:\TEMP\codes\PHI_Val_CC.cc',PHI_Val_CC);
% MAP1.Write_C_Code_To_File('C:\TEMP\codes\PHI_Grad_CC.cc',PHI_Grad_CC);
% MAP1.Write_C_Code_To_File('C:\TEMP\codes\PHI_Metric_CC.cc',PHI_Metric_CC);
% MAP1.Write_C_Code_To_File('C:\TEMP\codes\PHI_Det_Metric_CC.cc',PHI_Det_Metric_CC);
% MAP1.Write_C_Code_To_File('C:\TEMP\codes\PHI_Inv_Det_Metric_CC.cc',PHI_Inv_Det_Metric_CC);
% MAP1.Write_C_Code_To_File('C:\TEMP\codes\PHI_Inv_Metric_CC.cc',PHI_Inv_Metric_CC);
% MAP1.Write_C_Code_To_File('C:\TEMP\codes\PHI_Det_Jac_CC.cc',PHI_Det_Jac_CC);
% MAP1.Write_C_Code_To_File('C:\TEMP\codes\PHI_Det_Jac_w_Weight_CC.cc',PHI_Det_Jac_w_Weight_CC);
% MAP1.Write_C_Code_To_File('C:\TEMP\codes\PHI_Inv_Det_Jac_CC.cc',PHI_Inv_Det_Jac_CC);
% MAP1.Write_C_Code_To_File('C:\TEMP\codes\PHI_Inv_Grad_CC.cc',PHI_Inv_Grad_CC);
% MAP1.Write_C_Code_To_File('C:\TEMP\codes\PHI_Tangent_Vector_CC.cc',PHI_Tangent_Vector_CC);
% MAP1.Write_C_Code_To_File('C:\TEMP\codes\PHI_Normal_Vector_CC.cc',PHI_Normal_Vector_CC);
% MAP1.Write_C_Code_To_File('C:\TEMP\codes\PHI_Tan_Space_Proj_CC.cc',PHI_Tan_Space_Proj_CC);
% MAP1.Write_C_Code_To_File('C:\TEMP\codes\PHI_Hess_CC.cc',PHI_Hess_CC);
% MAP1.Write_C_Code_To_File('C:\TEMP\codes\PHI_2nd_Fund_Form_CC.cc',PHI_2nd_Fund_Form_CC);
% MAP1.Write_C_Code_To_File('C:\TEMP\codes\PHI_Det_2nd_Fund_Form_CC.cc',PHI_Det_2nd_Fund_Form_CC);
% MAP1.Write_C_Code_To_File('C:\TEMP\codes\PHI_Inv_Det_2nd_Fund_Form_CC.cc',PHI_Inv_Det_2nd_Fund_Form_CC);
% MAP1.Write_C_Code_To_File('C:\TEMP\codes\PHI_Total_Curvature_Vector_CC.cc',PHI_Total_Curvature_Vector_CC);
% MAP1.Write_C_Code_To_File('C:\TEMP\codes\PHI_Total_Curvature_CC.cc',PHI_Total_Curvature_CC);
% MAP1.Write_C_Code_To_File('C:\TEMP\codes\PHI_Gauss_Curvature_CC.cc',PHI_Gauss_Curvature_CC);

% write to a matlab file (for unit testing later)
Map_PHI( 1).Code = PHI_Mesh_Size_CC;
Map_PHI( 2).Code = PHI_Val_CC;
Map_PHI( 3).Code = PHI_Grad_CC;
Map_PHI( 4).Code = PHI_Metric_CC;
Map_PHI( 5).Code = PHI_Det_Metric_CC;
Map_PHI( 6).Code = PHI_Inv_Det_Metric_CC;
Map_PHI( 7).Code = PHI_Inv_Metric_CC;
Map_PHI( 8).Code = PHI_Det_Jac_CC;
Map_PHI( 9).Code = PHI_Det_Jac_w_Weight_CC;
Map_PHI(10).Code = PHI_Inv_Det_Jac_CC;
Map_PHI(11).Code = PHI_Inv_Grad_CC;
Map_PHI(12).Code = PHI_Tangent_Vector_CC;
Map_PHI(13).Code = PHI_Normal_Vector_CC;
Map_PHI(14).Code = PHI_Tan_Space_Proj_CC;
Map_PHI(15).Code = PHI_Hess_CC;
Map_PHI(16).Code = PHI_2nd_Fund_Form_CC;
Map_PHI(17).Code = PHI_Det_2nd_Fund_Form_CC;
Map_PHI(18).Code = PHI_Inv_Det_2nd_Fund_Form_CC;
Map_PHI(19).Code = PHI_Total_Curvature_Vector_CC;
Map_PHI(20).Code = PHI_Total_Curvature_CC;
Map_PHI(21).Code = PHI_Gauss_Curvature_CC;
if LIN_MAP_TF
    LM_str = 'true';
else
    LM_str = 'false';
end
FN_str = ['C:\TEMP\Map_PHI_Codes_', num2str(gd), num2str(td), '_', LM_str, '_NumBasis_', num2str(NB), '.mat'];
% save(FN_str,'Map_PHI');
%     end
% end

% END %