function FUNC_hess = Append_hess(obj,FUNC)
%Append_hess
%
%   This appends '_hessij' to the variable names.
%
%   FUNC_hess = obj.Append_hess(FUNC);
%
%   FUNC      = MxN cell array of strings representing symbolic variables.
%
%   FUNC_hess = similar to FUNC, except it is a DxDxMxN cell array (D is the
%               geometric dimension) and the strings have '_hessij' appended to
%               them, where the 'i' and 'j' are geometric component indices.

% Copyright (c) 08-14-2014,  Shawn W. Walker

GD = obj.Element.Domain.GeoDim;

% init cell array
[M, N] = size(FUNC);
FUNC_hess = cell(GD,GD,M,N);

for gd_i=1:GD
    for gd_j=1:GD
        for mm = 1:M
            for nn = 1:N
                FUNC_hess_comp = FUNC{mm,nn};
                FUNC_hess{gd_i,gd_j,mm,nn} = [FUNC_hess_comp, '_hess', num2str(gd_i),  num2str(gd_j)];
            end
        end
    end
end
FUNC_hess = squeeze(FUNC_hess);

end