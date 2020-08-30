function status = Process_Basis_Eval_to_CPP_Code_OLD(fid_Open,Eval_Basis,Vector_Comp,Deriv_Index,COMMENT)
%Process_Basis_Eval_to_CPP_Code_OLD
%
%   This takes given basis function evaluations and converts into C++ code!

% Copyright (c) 04-07-2010,  Shawn W. Walker

ENDL = '\n';
Num_Basis = length(Eval_Basis);

Multiindex_Length = Eval_Basis(1).Get_Length_Of_Multiindex;
Deriv_Index = Deriv_Index(1,1:Multiindex_Length); % remove unused indices

% get values
OUT_VAL = Eval_Basis(1).Get_Value(Vector_Comp,Deriv_Index);
FORMAT_STR = '%2.17E';

% do the other basis functions
for k=2:Num_Basis
    OUT_VAL = [OUT_VAL, Eval_Basis(k).Get_Value(Vector_Comp,Deriv_Index)];
    FORMAT_STR = [FORMAT_STR, ', %2.17E'];
end

Num_Lines = size(OUT_VAL,1);
if (Num_Lines > 1)
    % now loop through and output the basis function evaluations for each quad point
    status = fprintf(fid_Open, [COMMENT, '{', FORMAT_STR, '}, \\', ENDL],OUT_VAL(1:end-1,:)');
    % the last line does not have a comma!
    status = fprintf(fid_Open, [COMMENT, '{', FORMAT_STR, '}  \\', ENDL],OUT_VAL(end,:)');
elseif (Num_Lines == 1)
    % one line does not have a comma!
    status = fprintf(fid_Open, [COMMENT, '{', FORMAT_STR, '}  \\', ENDL],OUT_VAL(1,:)');
else
    error('Invalid!');
end

end