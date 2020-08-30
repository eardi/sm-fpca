function status = Write_Eval_Interp_routine(obj,fid_Open,Interp_INT)
%Write_Eval_Interp_routine
%
%   This generates the code that evaluates the local interpolation.

% Copyright (c) 02-04-2013,  Shawn W. Walker

ENDL = '\n';

% EXAMPLE:
% %%%%%%%
% /*------------ BEGIN: Auto Generate ------------*/
% /***************************************************************************************/
% /* evaluate component-wise interpolation expression */
% void SpecificFEM::Eval_Interp_00(double& INTERP)
% {
% 
%     // Compute interpolation
% 
%     // only one point for interpolation
%     for (unsigned int qp = 0; qp < 1; qp++)
%           INTERP = v_restricted_to_Omega->Func_f_Value[0][qp].a;
% }
% /***************************************************************************************/
% /*------------   END: Auto Generate ------------*/

% output text-lines
fprintf(fid_Open, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid_Open, ['/***************************************************************************************/', ENDL]);
fprintf(fid_Open, ['/* evaluate component-wise interpolation expression */', ENDL]);
row_str = num2str(Interp_INT.Row_Shift);
col_str = num2str(Interp_INT.Col_Shift);
fprintf(fid_Open, ['void SpecificFEM::Eval_Interp_', row_str, col_str, '(double& INTERP)', ENDL]);
fprintf(fid_Open, ['{', ENDL]);

% append Eval_Interp computation for the specific sub interpolation
Fixed_File = Interp_INT.Eval_Interp_snip;
status = obj.Append_ASCII_File_To_Open_File(Fixed_File,fid_Open);

% end the Eval Interp routine
fprintf(fid_Open, ['}', ENDL]);
fprintf(fid_Open, ['/***************************************************************************************/', ENDL]);
fprintf(fid_Open, [obj.END_Auto_Gen, ENDL]);
fprintf(fid_Open, ['', ENDL]); % close the snippet!

end