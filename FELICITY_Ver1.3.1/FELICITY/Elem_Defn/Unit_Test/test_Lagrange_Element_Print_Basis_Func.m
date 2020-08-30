function status = test_Lagrange_Element_Print_Basis_Func()
%test_Lagrange_Element_Print_Basis_Func
%
%   Test code for FELICITY class.

% Copyright (c) 05-20-2016,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

Elem_Lag = FELOutputElemInfo(lagrange_deg2_dim2);

OUT_STR = Elem_Lag.Print_Basis_Functions('latex');
Elem_Lag.Print_Basis_Functions;
Elem_Lag.Print_DoFs;

% RefDataFileName = fullfile(Current_Dir,'Lagrange_Element_Print_Basis_Func_REF_Data.mat');
% % OUT_STR_REF = OUT_STR;
% % save(RefDataFileName,'OUT_STR_REF');
% load(RefDataFileName);
% 
status = 0; % init
% % compare to reference data
% if ~isequal(OUT_STR,OUT_STR_REF)
%     disp(['Test Failed!']);
%     disp('Here are the discrepancies:');
%     for ind = 1:length(OUT_STR)
%         if ~isequal(OUT_STR(ind),OUT_STR_REF(ind))
%             disp('OUT_STR:');
%             OUT_STR(ind)
%             disp('OUT_STR_REF:');
%             OUT_STR_REF(ind)
%         end
%     end
%     status = 1;
% end

end