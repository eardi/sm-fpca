function status = Write_Tabulate_Tensor_routine(obj,fid_Open,Specific,sub_index)
%Write_Tabulate_Tensor_routine
%
%   This generates the code that computes the local element matrix
%   contribution.

% Copyright (c) 04-10-2010,  Shawn W. Walker

ENDL = '\n';

% EXAMPLE:
% %%%%%%%
% /*------------ BEGIN: Auto Generate ------------*/
% /***************************************************************************************/
% /* Tabulate the tensor for the local element contribution */
% void SpecificFEM::Tabulate_Tensor_0(double* A)
% {
%     // clear it first
%     for (unsigned int j = 0; j < COL_NB; j++)
%         for (unsigned int i = 0; i < ROW_NB; i++) A[j*ROW_NB + i] = 0.0;
% 
%     // get reference to jacobian data
%     const double * const DET_Jac_Weight = Mesh->Map.Grad_DET_w_Weight;
% 
%     // Compute element tensor using quadrature
% 
%     // Loop quadrature points for integral
%     for (unsigned int qp = 0; qp < NQ; qp++)
%         {
%         for (unsigned int j = 0; j < COL_NB; j++)
%             {
%             for (unsigned int i = 0; i < ROW_NB; i++)
%                 {
%                 A[j*ROW_NB + i] += Row_Basis_Val[qp][i] * Col_Basis_Val[qp][j] * DET_Jac_Weight[qp];
%                 }// end loop over 'i'
%             }// end loop over 'j'
%         }// end loop over 'qp'
% }
% /***************************************************************************************/
% /*------------   END: Auto Generate ------------*/

% parse
MAT = Specific.MAT;
MAT_SubMAT = MAT.SubMAT(sub_index);
% RowFunc = Specific.RowFunc;
% ColFunc = Specific.ColFunc;
GeoFunc = Specific.GeoFunc;

% tabulate_tensor number/index
cpp_ind = num2str(MAT_SubMAT.cpp_index);

% output text-lines
fprintf(fid_Open, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid_Open, ['/***************************************************************************************/', ENDL]);
fprintf(fid_Open, ['/* Tabulate the tensor for the local element contribution */', ENDL]);
fprintf(fid_Open, ['void SpecificFEM::Tabulate_Tensor_', cpp_ind, '(double* A, ', ENDL]);
% fprintf(fid_Open, ['                           ', RowFunc.CPP_Data_Type, '& row_basis_func,', ENDL]);
% fprintf(fid_Open, ['                           ', ColFunc.CPP_Data_Type, '& col_basis_func,', ENDL]);
fprintf(fid_Open, ['                           const ', GeoFunc.CPP.Data_Type_Name, '& ', 'Mesh)', ENDL]);
fprintf(fid_Open, ['{', ENDL]);
NQ_str = num2str(GeoFunc.Domain.Num_Quad);
fprintf(fid_Open, ['    ', 'const unsigned int NQ = ', NQ_str, ';', ENDL]);
fprintf(fid_Open, ['', ENDL]);
fprintf(fid_Open, ['    ', '// clear it first', ENDL]);
fprintf(fid_Open, ['    ', 'for (unsigned int ij = 0; ij < ROW_NB*COL_NB; ij++)', ENDL]);
fprintf(fid_Open, ['    ', '    A[ij] = 0.0;', ENDL]);

% append Tab_Tensor computation for the specific sub matrix
Fixed_File = MAT_SubMAT.Tab_Tensor_snip;
status = obj.Append_ASCII_File_To_Open_File(Fixed_File,fid_Open);

% end the Tab Tensor routine
fprintf(fid_Open, ['}', ENDL]);
fprintf(fid_Open, ['/***************************************************************************************/', ENDL]);
fprintf(fid_Open, [obj.END_Auto_Gen, ENDL]);

fprintf(fid_Open, ['', ENDL]); % close the snippet!

end