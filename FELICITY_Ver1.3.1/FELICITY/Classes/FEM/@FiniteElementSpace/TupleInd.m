function TI = TupleInd(obj,Linear_Ind)
%TupleInd
%
%   This converts a linear index (for indexing into the cartesian product
%   FE space along columns) into a tuple pair index.  E.g.
%
%   G = [V_11, V_12;          G = [V_1, V_4;
%        V_21, V_22;   <==>        V_2, V_5;
%        V_31, V_32]               V_3, V_6]
%
%   where G is the "big" FE space that is a cartesian product of many base
%   FE spaces.  So if G is of (block) size M x N, then a block with tuple
%   index pair (i,j) has linear index k = i + (j-1)*M.
%   Note: see also the method "LinearInd", and the Matlab command "ind2sub".
%
%   TI = obj.TupleInd(Linear_Ind);
%
%   INPUTS:
%   Linear_Ind = positive integer representing the linear index.
%                Note: must satisfy 1 <= Linear_Ind <= 
%
%   OUTPUTS:
%   TI = a 1x2 row vector representing (i,j) (the corresponding tuple index).

% Copyright (c) 03-26-2018,  Shawn W. Walker

TOTAL_Comp = prod(obj.Num_Comp);
if or(Linear_Ind < 1,Linear_Ind > TOTAL_Comp)
    err = FELerror;
    err = err.Add_Comment(['The tuple-size of the FE space is ', num2str(obj.Num_Comp), ',']);
    err = err.Add_Comment(['    so, the total number of components is ', num2str(prod(obj.Num_Comp)), '.']);
    err = err.Add_Comment(['The given linear index ', num2str(Linear_Ind), ' is too large!']);
    err.Error;
    error('Invalid linear index!');
end

TI = zeros(1,2);
[TI(1), TI(2)] = ind2sub(obj.Num_Comp,Linear_Ind);

end