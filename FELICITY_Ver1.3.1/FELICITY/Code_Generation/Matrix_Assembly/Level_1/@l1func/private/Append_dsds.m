function FUNC_dsds = Append_dsds(obj,FUNC)
%Append_dsds
%
%   This appends '_dsds' to the variable names.
%
%   FUNC_dsds = obj.Append_dsds(FUNC);
%
%   FUNC      = MxN cell array of strings representing symbolic variables.
%
%   FUNC_dsds = similar to FUNC, except the strings have '_dsds' appended to them.

% Copyright (c) 08-06-2014,  Shawn W. Walker

FUNC_col = FUNC(:); % init

FUNC_dsds = FUNC_col;
for ind = 1:length(FUNC_col)
    FUNC_dsds{ind} = [FUNC_dsds{ind}, '_dsds'];
end

FUNC_dsds = reshape(FUNC_dsds,size(FUNC));
%FUNC_dsds = squeeze(FUNC_dsds);

end