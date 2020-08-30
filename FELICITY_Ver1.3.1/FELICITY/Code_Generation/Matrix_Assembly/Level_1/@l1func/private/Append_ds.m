function FUNC_ds = Append_ds(obj,FUNC)
%Append_ds
%
%   This appends '_ds' to the variable names.
%
%   FUNC_ds = obj.Append_ds(FUNC);
%
%   FUNC    = MxN cell array of strings representing symbolic variables.
%
%   FUNC_ds = similar to FUNC, except the strings have '_ds' appended to them.

% Copyright (c) 08-01-2011,  Shawn W. Walker

FUNC_col = FUNC(:); % init

FUNC_ds = FUNC_col;
for ind = 1:length(FUNC_col)
    FUNC_ds{ind} = [FUNC_ds{ind}, '_ds'];
end

FUNC_ds = reshape(FUNC_ds,size(FUNC));
%FUNC_ds = squeeze(FUNC_ds);

end