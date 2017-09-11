function status = test_BDM_Element_Print_Basis_Func()
%test_BDM_Element_Print_Basis_Func
%
%   Test code for FELICITY class.

% Copyright (c) 04-30-2012,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

Elem_BDM = FELOutputElemInfo(brezzi_douglas_marini_deg1_dim2);

OUT_STR = Elem_BDM.Print_Basis_Functions('latex');
Elem_BDM.Print_Basis_Functions;
Elem_BDM.Print_DoFs;

RefDataFileName = fullfile(Current_Dir,'BDM_Element_Print_Basis_Func_REF_Data.mat');
% OUT_STR_REF = OUT_STR;
% save(RefDataFileName,'OUT_STR_REF');
load(RefDataFileName);

status = 0; % init
% compare to reference data
if ~isequal(OUT_STR,OUT_STR_REF)
    disp(['Test Failed!']);
    status = 1;
end

end