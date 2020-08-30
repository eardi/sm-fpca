function obj_diff = Differentiate(obj,alpha)
%Differentiate
%
%   This returns a FELSymFunc object that comes from differentiating the
%   internal sym function.
%
%   obj_diff = obj.Differentiate(alpha);
%
%   alpha = 1xN vector that contains the derivatives to compute in multi-index
%           notation.  N = number of independent variables of the function.

% Copyright (c) 10-31-2016,  Shawn W. Walker

if (nargin==1)
    alpha = zeros(1,obj.input_dim); % no derivatives
end
if (length(alpha)~=obj.input_dim)
    error('The alpha multi-index (i.e. the input) does not have the correct number of indices.');
end

TEMP = obj.Func; % init

Deriv_Order = sum(alpha);
if (Deriv_Order > 0)
    Diff_Vars = cell(1,Deriv_Order);
    CNT = 0;
    for ii = 1:obj.input_dim
        for aa = 1:alpha(ii)
            Diff_Vars{CNT+aa} = obj.Vars{ii};
        end
        CNT = CNT + alpha(ii);
    end
    
    if (Deriv_Order==1)
        TEMP = diff(TEMP,Diff_Vars{1});
    elseif (Deriv_Order==2)
        TEMP = diff(TEMP,Diff_Vars{1},Diff_Vars{2});
    elseif (Deriv_Order==3)
        TEMP = diff(TEMP,Diff_Vars{1},Diff_Vars{2},Diff_Vars{3});
    elseif (Deriv_Order==4)
        TEMP = diff(TEMP,Diff_Vars{1},Diff_Vars{2},Diff_Vars{3},Diff_Vars{4});
    else
        error('Not implemented!');
    end
    % SWW: this is a bit faster now, but still slow
    if ~isa(TEMP,'sym')
        TEMP = sym(TEMP);
    end
end

obj_diff = obj; % init
obj_diff.Func = TEMP; % overwrite the symbolic (sym) function

end