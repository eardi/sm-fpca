function FUNC_tilde = Reduce_Components(obj,FUNC,VARARG)
%Reduce_Components
%
%   This extracts a subset of the function components.
%
%   FUNC_tilde = obj.Reduce_Components(FUNC,VARARG);
%
%   FUNC   = MxN cell array of strings representing symbolic variables.
%   VARARG = sequence of positive indices specifying the components of FUNC that
%            we want.
%
%   FUNC_tilde = similar to FUNC, except with reduced number of components.

% Copyright (c) 08-01-2011,  Shawn W. Walker

NARG = length(VARARG);

if NARG==0
    FUNC_tilde = FUNC;
elseif NARG==1
    FUNC_tilde = shiftdim(FUNC(VARARG{1},:,:,:,:,:));
elseif NARG==2
    FUNC_tilde = shiftdim(FUNC(VARARG{1},VARARG{2},:,:,:,:));
elseif NARG==3
    FUNC_tilde = shiftdim(FUNC(VARARG{1},VARARG{2},VARARG{3},:,:,:));
elseif NARG==4
    FUNC_tilde = shiftdim(FUNC(VARARG{1},VARARG{2},VARARG{3},VARARG{4},:,:));
elseif NARG==5
    FUNC_tilde = shiftdim(FUNC(VARARG{1},VARARG{2},VARARG{3},VARARG{4},VARARG{5},:));
elseif NARG==6
    FUNC_tilde = shiftdim(FUNC(VARARG{1},VARARG{2},VARARG{3},VARARG{4},VARARG{5},VARARG{6}));
else
    error('Not implemented!');
end

end