function FUNC_curl = Append_curl(obj,FUNC)
%Append_curl
%
%   This appends '_curl' to the variable names.
%
%   FUNC_curl = obj.Append_curl(FUNC);
%
%   FUNC      = MxN cell array of strings representing symbolic variables.
%
%   FUNC_curl = similar to FUNC, except the strings have '_curl' appended to them.

% Copyright (c) 11-04-2016,  Shawn W. Walker

% TD = obj.Element.Domain.GeoDim;
% GD = obj.Element.Domain.GeoDim;

% init
FUNC_col = FUNC(:);

FUNC_curl = FUNC_col;
for ind = 1:length(FUNC_col)
    FUNC_curl{ind} = [FUNC_curl{ind}, '_curl'];
end

FUNC_curl = reshape(FUNC_curl,size(FUNC));
%FUNC_curl = squeeze(FUNC_curl);

end