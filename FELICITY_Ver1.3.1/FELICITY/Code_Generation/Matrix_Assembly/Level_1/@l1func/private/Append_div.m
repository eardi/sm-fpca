function FUNC_div = Append_div(obj,FUNC)
%Append_div
%
%   This appends '_div' to the variable names.
%
%   FUNC_div = obj.Append_div(FUNC);
%
%   FUNC     = MxN cell array of strings representing symbolic variables.
%
%   FUNC_div = similar to FUNC, except the strings have '_div' appended to them.

% Copyright (c) 08-01-2011,  Shawn W. Walker

FUNC_col = FUNC(:); % init

FUNC_div = FUNC_col;
for ind = 1:length(FUNC_col)
    FUNC_div{ind} = [FUNC_div{ind}, '_div'];
end

FUNC_div = reshape(FUNC_div,size(FUNC));
%FUNC_div = squeeze(FUNC_div);

end