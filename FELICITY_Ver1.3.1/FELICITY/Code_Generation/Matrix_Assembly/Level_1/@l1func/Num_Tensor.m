function [NR, NC] = Num_Tensor(obj)
%Num_Tensor
%
%   This returns the tuple size of the function (i.e. the matrix size).
%
%   [NR, NC] = obj.Num_Tensor;
%       OR
%   SIZE = obj.Num_Tensor;
%   where  SIZE = [NR, NC].

% Copyright (c) 03-23-2018,  Shawn W. Walker

% error check
if (length(obj.Element.Tensor_Comp)~=2)
    error('The Tensor_Comp should be length 2!');
end

if (nargout==1)
    NR = obj.Element.Tensor_Comp;
else
    NR = obj.Element.Tensor_Comp(1);
    NC = obj.Element.Tensor_Comp(2);
end

end