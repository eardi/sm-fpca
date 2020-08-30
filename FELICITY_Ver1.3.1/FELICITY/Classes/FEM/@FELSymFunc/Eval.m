function Values = Eval(obj,Pt)
%Eval
%
%   This evaluates the expression at the given points.
%
%   Values = obj.Eval(Pt);
%
%   Pt = MxT matrix of point coordinates.  Column i corresponds to the ith
%        independent variable.  M = number of points.
%        Note: T <= N = number of independent variables.  If T < N, then the
%        first T independent variables are set by Pt, and the rest are set to
%        zero.
%
%   Values = RxC cell array of column vectors.  R,C is the matrix size of
%            obj.Func.  The (i,j) entry of Values is a column vector of length M
%            that corresponds to evaluating obj.Func(i,j) at the points in 'Pt'.

% Copyright (c) 02-28-2013,  Shawn W. Walker

[Num_Vec_ROW, Num_Vec_COL] = obj.output_size;

Values = cell(Num_Vec_ROW,Num_Vec_COL); % init

Num_Pt  = size(Pt,1);
Top_Dim = size(Pt,2);

% ignore this error check if there are *no* arguments
if and(obj.input_dim > 0,Top_Dim > obj.input_dim)
    error('The dimension of the points is larger than the number of independent variables!');
end

ZERO_VEC = zeros(Num_Pt,1);

Pt = [Pt, zeros(Num_Pt,obj.input_dim-Top_Dim)]; % append extra zeros for remaining variables

for ri = 1:Num_Vec_ROW
    for ci = 1:Num_Vec_COL
        
        TEMP = obj.subs_H(obj.Func(ri,ci),obj.Vars,num2cell(Pt,1));
        % make sure this is of type double
        TEMP = double(TEMP);
        if (size(TEMP,1)~=Num_Pt) % in case the symbolic function is a constant!
            Values{ri,ci} = TEMP + ZERO_VEC;
        else
            Values{ri,ci} = TEMP;
        end
        
    end
end

end