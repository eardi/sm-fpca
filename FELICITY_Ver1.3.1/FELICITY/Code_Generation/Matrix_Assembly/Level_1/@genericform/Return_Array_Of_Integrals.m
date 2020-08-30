function [OUT_ID, rc_index] = Return_Array_Of_Integrals(obj)
%Return_Array_Of_Integrals
%
%   This returns a linear array of Integrals.
%   Note: this combines the Integrals for the Real case.
%
%   [OUT_ID, rc_index] = obj.Return_Array_Of_Integrals;
%
%   OUT_ID   = array (length M) of Level 1 Integral(s).
%   rc_index = Mx2 matrix of indices [r,c]; these are indices into
%              obj(r,c).Integral.

% Copyright (c) 06-22-2012,  Shawn W. Walker

num_row = size(obj,1);
num_col = size(obj,2);

OUT_ID = [];
rc_index = [];
for ir = 1:num_row
    for ic = 1:num_col
        ID = obj(ir,ic).Integral;
        num_ID = length(ID);
        rv = ir * ones(num_ID,1);
        cv = ic * ones(num_ID,1);
        temp_index = [rv, cv];
        OUT_ID = [OUT_ID; ID];
        rc_index = [rc_index; temp_index];
    end
end

end