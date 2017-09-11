function NT = Num_Tensor(obj)
%Num_Tensor
%
%   This returns the number of tensor components.
%
%   NT = obj.Num_Tensor;

% Copyright (c) 08-01-2011,  Shawn W. Walker

NT = prod(obj.Element.Tensor_Comp);

end