function IS_DISTINCT = Check_Distinct_Names(obj)
%Check_Distinct_Names
%
%   This returns whether all of the elements have distinct names.

% Copyright (c) 04-07-2010,  Shawn W. Walker

IS_DISTINCT = true;
Num_Elem = length(obj.Elem);

for i1 = 1:Num_Elem
    NAME = obj.Elem(i1).Name;
    for i2 = i1+1:Num_Elem
        if strcmp(NAME,obj.Elem(i2).Name);
            IS_DISTINCT = false;
        end
    end
end

if ~IS_DISTINCT
    err = FELerror;
    err = err.Add_Comment(['Some of these Element.Name''s are identical: ']);
    for i1 = 1:Num_Elem
        err = err.Add_Comment(obj.Elem(i1).Name);
    end
    err = err.Add_Comment('All Element.Name''s must be distinct!');
    err.Error;
    error('stop!');
end

end