function Integral_SubMAT_Index = Set_COPY_Struct(L2_Obj_Integral,SubMAT_Index)
%Set_COPY_Struct
%
%   Do checks to see if the sub-matrix is identical to others.  If so, then you
%   can just COPY that matrix over.

% Copyright (c) 06-25-2012,  Shawn W. Walker

Num_Integral = length(L2_Obj_Integral);
Integral_SubMAT_Index = L2_Obj_Integral(SubMAT_Index); % init

if (Num_Integral==1)
    return; % nothing to copy yet...
end

% check all the integrals to see if they are the same as "Integral_SubMAT_Index"
for ind = 1:Num_Integral
    if (ind ~= SubMAT_Index) % obviously, ignore the SELF case
        [Integral_SubMAT_Index, COPIED] = Set_COPY_Struct_internal(Integral_SubMAT_Index,L2_Obj_Integral(ind),'default');
        if ~COPIED
            TEMP_L2_Obj_Integral_ind = L2_Obj_Integral(ind);
            if and(~isempty(TEMP_L2_Obj_Integral_ind.TestF),~isempty(TEMP_L2_Obj_Integral_ind.TrialF))
                % switch test and trial functions
                TEMP_L2_Obj_Integral_ind.Arg = Swap_Test_And_Trial_Functions(TEMP_L2_Obj_Integral_ind);
                % try to copy again
                Integral_SubMAT_Index = Set_COPY_Struct_internal(Integral_SubMAT_Index,TEMP_L2_Obj_Integral_ind,'transpose');
            end
        end
    end
end

end

function [Integral_Out, COPIED] = Set_COPY_Struct_internal(Int_A,Int_B,type)
%Set_COPY_Struct_default
%
%   If Integral A and Integral B are the same, then let A copy B;
%   recall the routine "Make_Integrand_Use_1st_Tensor_Components"

% Copyright (c) 08-01-2011,  Shawn W. Walker

Integral_Out = Int_A; % init
if ~isempty(Integral_Out.COPY)
    % this has already been copied!
    COPIED = true;
    return;
end

% otherwise, see if you can copy!
COPIED = false;
A = Int_A.Arg; % store it
if isempty(Int_B.COPY)
    B = Int_B.Arg;
    
    if (A==B)
        COPIED = true;
        % change the Integral struct
        Integral_Out.Original = [];
        COPY = Get_L2_Obj_Integral_COPY_Struct();
        COPY.Use_SubMAT_Index = Int_B.SubMAT_Index;
        COPY.row_index        = Int_B.row_index;
        COPY.col_index        = Int_B.col_index;
        COPY.type             = type;
        Integral_Out.COPY     = COPY;
    end
end

end