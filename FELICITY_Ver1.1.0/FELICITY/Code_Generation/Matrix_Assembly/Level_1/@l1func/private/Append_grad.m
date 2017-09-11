function FUNC_grad = Append_grad(obj,FUNC)
%Append_grad
%
%   This appends '_gradk' to the variable names.
%
%   FUNC_grad = obj.Append_grad(FUNC);
%
%   FUNC      = MxN cell array of strings representing symbolic variables.
%
%   FUNC_grad = similar to FUNC, except it is an MxNxD cell array (D is the
%               geometric dimension) and the strings have '_gradk' appended to
%               them, where the 'k' is a geometric component index.

% Copyright (c) 08-01-2011,  Shawn W. Walker

GD = obj.Element.Domain.GeoDim;

FUNC_col = FUNC(:); % init

FUNC_grad = [];
for gd_i=1:GD
    FUNC_grad_comp = FUNC_col;
    for ind = 1:length(FUNC_col)
        FUNC_grad_comp{ind} = [FUNC_grad_comp{ind}, '_grad', num2str(gd_i)];
    end
    FUNC_grad = [FUNC_grad; FUNC_grad_comp];
end

%SF = size(FUNC);
FUNC_grad = reshape(FUNC_grad,[size(FUNC), GD]);
FUNC_grad = squeeze(FUNC_grad);

end