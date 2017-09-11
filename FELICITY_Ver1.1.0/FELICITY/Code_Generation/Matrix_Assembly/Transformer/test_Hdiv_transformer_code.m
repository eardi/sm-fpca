% test_Hdiv_transformer_code
%
% unofficial test code
clc;
clear all classes;

LIN_MAP_TF = true;
for ii=2:3
    for jj=ii:3

gd = jj;
td = ii;
MAP1 = Geometric_Trans('geo_test',gd,td,LIN_MAP_TF);
FUNC1 = Hdiv_Trans('func_test',MAP1);
FUNC1.vv

FUNC_Orientation_CC             = FUNC1.FUNC_Orientation_C_Code;
FUNC_Val_CC                     = FUNC1.FUNC_Val_C_Code;
FUNC_Div_CC                     = FUNC1.FUNC_Div_C_Code;
COEF_FUNC_Val_CC                = FUNC1.COEF_FUNC_Val_C_Code;
COEF_FUNC_Div_CC                = FUNC1.COEF_FUNC_Div_C_Code;

% % %%%%%%%
% FUNC1.Write_C_Code_To_File('C:\TEMP\codes\FUNC_Orientation_CC.cc',FUNC_Orientation_CC);
% FUNC1.Write_C_Code_To_File('C:\TEMP\codes\FUNC_Val_CC.cc',FUNC_Val_CC);
% FUNC1.Write_C_Code_To_File('C:\TEMP\codes\FUNC_Div_CC.cc',FUNC_Div_CC);
% FUNC1.Write_C_Code_To_File('C:\TEMP\codes\COEF_FUNC_Val_CC.cc',COEF_FUNC_Val_CC);
% FUNC1.Write_C_Code_To_File('C:\TEMP\codes\COEF_FUNC_Div_CC.cc',COEF_FUNC_Div_CC);

% write to a matlab file (for unit testing later)
Func_vv( 1).Code = FUNC_Orientation_CC;
Func_vv( 2).Code = FUNC_Val_CC;
Func_vv( 3).Code = FUNC_Div_CC;
Func_vv( 4).Code = COEF_FUNC_Val_CC;
Func_vv( 5).Code = COEF_FUNC_Div_CC;
if LIN_MAP_TF
    LM_str = 'true';
else
    LM_str = 'false';
end
FN_str = ['C:\TEMP\Func_vv_Hdiv_Codes_', num2str(gd), num2str(td), '_', LM_str, '.mat'];
%save(FN_str,'Func_vv');
    end
end

% END %