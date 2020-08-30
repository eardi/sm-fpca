function Comp_Ind_1x2 = Process_Tuple_Component(obj,Comp_Ind)
%Process_Tuple_Component
%
%   This takes a given tuple component index, checks that it is consistent
%   with obj.Num_Comp, and processes it for *internal* use.
%
%   Comp_Ind_1x2 = obj.Process_Tuple_Component(Comp_Ind);
%
%   obj = object of *this class.
%   Comp_Ind = either a 1x1 matrix, or a 1x2 row vector.  Suppose the FE
%              space G is constructed as a cartesian product of base FE
%              spaces (referred to as V), where the product space is
%              "stored" as
%                  G = [V x V ... x V;
%                       ...
%                       V x V ... x V],
%              where G is of (block) size [M, N] (we refer to this as the
%              tuple-size).  Then Comp_Ind should index in this structure.
%              Note:  Comp_Ind is only allowed to be 1x1 if N = 1;

% Copyright (c) 03-26-2018,  Shawn W. Walker

if (length(Comp_Ind)==1)
    if (obj.Num_Comp(2) > 1)
        err = FELerror;
        err = err.Add_Comment('Given Comp_Ind index must be a 1x2 row vector!');
        err = err.Add_Comment('     Because tuple size is M x N, with N > 1,');
        err = err.Add_Comment('     and Comp_Ind must index into the tuple structure.');
        err.Error;
        error('stop!');
    else
        Comp_Ind_1x2 = [Comp_Ind(1), 1];
    end
elseif (length(Comp_Ind)==2)
    Comp_Ind_1x2 = Comp_Ind;
else
    err = FELerror;
    err = err.Add_Comment('Given Comp_Ind index must be either a 1x1 or a 1x2 row vector!');
    err.Error;
    error('stop!');
end

if (min(Comp_Ind_1x2) < 1)
    err = FELerror;
    err = err.Add_Comment('Given Comp_Ind indices must be >= 1!');
    err.Error;
    error('stop!');
end

if or(Comp_Ind_1x2(1) > obj.Num_Comp(1), Comp_Ind_1x2(2) > obj.Num_Comp(2))
    err = FELerror;
    err = err.Add_Comment(['The tuple-size of the FE space is ', num2str(obj.Num_Comp), '.']);
    err = err.Add_Comment(['The given Comp_Ind indices ', num2str(Comp_Ind_1x2), ' are too large!']);
    err.Error;
    error('stop!');
end

% if ~isnumeric(Comp)
%     error('Given components "Comp" must be integers!');
% end

end