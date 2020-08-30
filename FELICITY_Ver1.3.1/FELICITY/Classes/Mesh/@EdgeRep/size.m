function SIZE = size(obj,rc_ind)
%edgeTangents
%
%   This mimics the analogous MATLAB:TriRep method.
%
%   SIZE = obj.size;
%
%   SIZE = 1x2 vector containing dimensions of obj.ConnectivityList.

% Copyright (c) 07-25-2014,  Shawn W. Walker

SIZE = size(obj.ConnectivityList); % init

if nargin==2
    if or(rc_ind==1,rc_ind==2)
        SIZE = SIZE(rc_ind);
    else
        error('Input index is not valid.  Must be 1 or 2!');
    end
end

end