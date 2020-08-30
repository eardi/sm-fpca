function obj = Gen_Tab_Tensor_snippet(obj,GeoFunc,BF,Ccode_Frag)
%Gen_Tab_Tensor_snippet
%
%   This encapsulates the code generation for computing the local element matrix.

% Copyright (c) 06-13-2016,  Shawn W. Walker

% open file for writing
File1 = [obj.Name, '.cpp'];
WRITE_File = fullfile(obj.Snippet_Dir, File1);
obj.Tab_Tensor_Code = WRITE_File;
fid_Open = fopen(WRITE_File, 'w');

ENDL = '\n';

% EXAMPLE:
% % %%%%%%%
% /***************************************************************************************/
% /* Tabulate the tensor for the local element contribution */
% void SpecificFEM::Tabulate_Tensor(double* A1, double* A2, double* A3, 
%                                   const CLASS_geom_Gamma_embedded_in_Gamma_restricted_to_Gamma& Mesh)
% {
%     const unsigned int NQ = 19;
% 
%     // Compute element tensor using quadrature
% 
%     // Loop quadrature points for integral
%     for (unsigned int i = 0; i < ROW_NB; i++)
%         {
%         double  A1_value = 0.0; // initialize
%         double  A2_value = 0.0; // initialize
%         double  A3_value = 0.0; // initialize
%         for (unsigned int qp = 0; qp < NQ; qp++)
%             {
%             double  integrand_1 = geom_Gamma_embedded_in_Gamma_restricted_to_Gamma->Map_Normal_Vector[qp].v[0]*(*Vector_P1_phi_restricted_to_Gamma->Func_f_Value)[i][qp].a;
%             double  integrand_2 = geom_Gamma_embedded_in_Gamma_restricted_to_Gamma->Map_Normal_Vector[qp].v[1]*(*Vector_P1_phi_restricted_to_Gamma->Func_f_Value)[i][qp].a;
%             double  integrand_3 = geom_Gamma_embedded_in_Gamma_restricted_to_Gamma->Map_Normal_Vector[qp].v[2]*(*Vector_P1_phi_restricted_to_Gamma->Func_f_Value)[i][qp].a;
%             A1_value += integrand_1 * Mesh.Map_Det_Jac_w_Weight[qp].a;
%             A2_value += integrand_2 * Mesh.Map_Det_Jac_w_Weight[qp].a;
%             A3_value += integrand_3 * Mesh.Map_Det_Jac_w_Weight[qp].a;
%             }
%         A1[i] = A1_value;
%         A2[i] = A2_value;
%         A3[i] = A3_value;
%         }
% }
% /***************************************************************************************/

% output text-lines
fprintf(fid_Open, ['/***************************************************************************************/', ENDL]);
fprintf(fid_Open, ['/* Tabulate the tensor for the local element contribution */', ENDL]);
fprintf(fid_Open, ['void SpecificFEM::Tabulate_Tensor(const ', GeoFunc.CPP.Data_Type_Name, '& ', 'Mesh)', ENDL]);
fprintf(fid_Open, ['{', ENDL]);
NQ_str = num2str(GeoFunc.Domain.Num_Quad);
fprintf(fid_Open, ['    ', 'const unsigned int NQ = ', NQ_str, ';', ENDL]);

% if all sub-matrices are symmetric, then we can optimize the quadrature
% loop by only computing the upper triangular part of the matrix
All_SubMATs_Symmetric = true;
for ind = 1: obj.Num_SubMAT
    if ~(obj.SubMAT(ind).Symmetric)
        All_SubMATs_Symmetric = false;
        break;
    end
end

% generate quadrature loop!
Comp_Order = obj.SubMAT_Computation_Order;
Gen_CPP_Quad_Loop_Code(fid_Open,Comp_Order,All_SubMATs_Symmetric,Ccode_Frag,BF.v,BF.u);

% end the Tab Tensor routine
fprintf(fid_Open, ['}', ENDL]);
fprintf(fid_Open, ['/***************************************************************************************/', ENDL]);

% DONE!
fclose(fid_Open);

end