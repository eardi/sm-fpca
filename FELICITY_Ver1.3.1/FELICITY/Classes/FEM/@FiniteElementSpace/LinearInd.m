function LI = LinearInd(obj,Tuple_Ind)
%LinearInd
%
%   This converts a tuple index pair (for indexing into the cartesian
%   product FE space) into a linear index that goes along columns.  E.g.
%
%   G = [V_11, V_12;          G = [V_1, V_4;
%        V_21, V_22;   <==>        V_2, V_5;
%        V_31, V_32]               V_3, V_6]
%
%   where G is the "big" FE space that is a cartesian product of many base
%   FE spaces.  So if G is of (block) size M x N, then a block with tuple
%   index pair (i,j) has linear index k = i + (j-1)*M.
%   Note: see also the method "TupleInd", and the Matlab command "sub2ind".
%
%   LI = obj.LinearInd(Tuple_Ind);
%
%   INPUTS:
%   Tuple_Ind = a 1x1 or 1x2 row vector representing (i,j).
%               Note: if 1x1, then N must be 1. In this case,
%               LI = Tuple_Ind.
%
%   OUTPUTS:
%   LI = the corresponding linear index.

% Copyright (c) 03-26-2018,  Shawn W. Walker

Tuple_Ind = obj.Process_Tuple_Component(Tuple_Ind);

%LI = Tuple_Ind(1) + (Tuple_Ind(2) - 1)*obj.Num_Comp(1);
LI = sub2ind(obj.Num_Comp,Tuple_Ind(1),Tuple_Ind(2));

end