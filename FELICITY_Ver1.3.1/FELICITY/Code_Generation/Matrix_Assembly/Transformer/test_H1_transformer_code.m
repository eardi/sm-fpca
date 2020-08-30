% test_H1_transformer_code
%
% unofficial test code
clc;
clear all classes;

LIN_MAP_TF = true;
for ii=1:3
    for jj=ii:3

gd = jj;
td = ii;
MAP1 = Geometric_Trans('geo_test',gd,td,LIN_MAP_TF);
FUNC1 = H1_Trans('func_test',MAP1);
FUNC1.f

FUNC_Val_CC                     = FUNC1.FUNC_Val_C_Code;
FUNC_Val_special_CC             = FUNC1.FUNC_Val_special_C_Code;
FUNC_d_ds_CC                    = FUNC1.FUNC_d_ds_C_Code;
FUNC_Grad_CC                    = FUNC1.FUNC_Grad_C_Code;
% FUNC_Hess_CC                    = FUNC1.FUNC_Hess_C_Code;
COEF_FUNC_Val_CC                = FUNC1.COEF_FUNC_Val_C_Code;
COEF_FUNC_d_ds_CC               = FUNC1.COEF_FUNC_d_ds_C_Code;
COEF_FUNC_Grad_CC               = FUNC1.COEF_FUNC_Grad_C_Code;
% COEF_FUNC_Hess_CC                    = FUNC1.COEF_FUNC_Hess_C_Code;

% %%%%%%%
% FUNC1.Write_C_Code_To_File('C:\TEMP\codes\FUNC_Val_CC.cc',FUNC_Val_CC);
% FUNC1.Write_C_Code_To_File('C:\TEMP\codes\FUNC_Val_Special_CC.cc',FUNC_Val_special_CC);
% FUNC1.Write_C_Code_To_File('C:\TEMP\codes\FUNC_d_ds_CC.cc',FUNC_d_ds_CC);
% FUNC1.Write_C_Code_To_File('C:\TEMP\codes\FUNC_Grad_CC.cc',FUNC_Grad_CC);
% FUNC1.Write_C_Code_To_File('C:\TEMP\codes\COEF_FUNC_Val_CC.cc',COEF_FUNC_Val_CC);
% FUNC1.Write_C_Code_To_File('C:\TEMP\codes\COEF_FUNC_d_ds_CC.cc',COEF_FUNC_d_ds_CC);
% FUNC1.Write_C_Code_To_File('C:\TEMP\codes\COEF_FUNC_Grad_CC.cc',COEF_FUNC_Grad_CC);

% write to a matlab file (for unit testing later)
Func_f( 1).Code = FUNC_Val_CC;
Func_f( 2).Code = FUNC_Val_special_CC;
Func_f( 3).Code = FUNC_d_ds_CC;
Func_f( 4).Code = FUNC_Grad_CC;
Func_f( 5).Code = COEF_FUNC_Val_CC;
Func_f( 6).Code = COEF_FUNC_d_ds_CC;
Func_f( 7).Code = COEF_FUNC_Grad_CC;
if LIN_MAP_TF
    LM_str = 'true';
else
    LM_str = 'false';
end
FN_str = ['C:\TEMP\Func_f_Codes_', num2str(gd), num2str(td), '_', LM_str, '.mat'];
%save(FN_str,'Func_f');
    end
end

% END %