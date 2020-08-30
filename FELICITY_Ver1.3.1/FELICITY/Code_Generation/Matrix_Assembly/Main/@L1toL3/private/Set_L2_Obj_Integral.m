function L2_Obj_Integral = Set_L2_Obj_Integral(Matrix_Data,Integral_struct)
%Set_L2_Obj_Integral
%
%   This outputs a convenient struct.
%
%   Level 1 genericform:
%   Matrix_Data.Name
%   Matrix_Data.Test_Space
%   Matrix_Data.Trial_Space
%   Matrix_Data.Integral
%
%   Integral_struct.Integrand_Sym
%   Integral_struct.Domain
%   Integral_struct.TestF
%   Integral_struct.TrialF
%   Integral_struct.Integration_Index = k in "FM.Integration(k)", where FM is a
%                                       FELMatrices object.

% Copyright (c) 04-18-2018,  Shawn W. Walker

% init
L2_Obj_Integral = Get_L2_Obj_Integral_Struct();
ZERO = sym(0);

% Note: the sub-matrices will be ordered column-wise:
% e.g. if M is a 3x3 block matrix, then
%
% M = [M_1, M_4, M_7;
%      M_2, M_5, M_8;
%      M_3, M_6, M_9]
%
% So, make sure loop columns, then rows...??

SubMAT_Index = 0;
for ci = 1:size(Integral_struct.Integrand_Sym,2)
    for ri = 1:size(Integral_struct.Integrand_Sym,1)
        if ~(Integral_struct.Integrand_Sym(ri,ci)==ZERO)
            SubMAT_Index = SubMAT_Index + 1; % we are SETTING the SubMAT_Index here!
            STR1 = char(Integral_struct.Integrand_Sym(ri,ci));
            % set matrix integrand to only use 1st tensor components of basis
            % functions
            Integrand_sym_NEW = Make_Integrand_Use_1st_Tensor_Components(...
                                Integral_struct.TestF,Integral_struct.TrialF,Integral_struct.Integrand_Sym(ri,ci));
            Domain = Integral_struct.Domain{ri,ci};
            
            % set the L2 object integral
            MAT_Name = Matrix_Data(1,1).Name; % all the names should be the same
            L2_Obj_Integral(SubMAT_Index) = Set_Integral_Struct(MAT_Name,Domain,...
                                                Integral_struct.TestF,Integral_struct.TrialF,...
                                                SubMAT_Index,ri,ci,STR1,Integrand_sym_NEW);
            if ~isa(Matrix_Data,'Real')
                % do checks to see if the sub-matrix is identical to others....
                L2_Obj_Integral(SubMAT_Index) = Set_COPY_Struct(L2_Obj_Integral,SubMAT_Index);
            end
        end
    end
end

end