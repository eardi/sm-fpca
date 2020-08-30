function obj = inverse_det_second_fund_form(obj)
%inverse_det_second_fund_form
%
%   Get the INVERSE of determinant of the second fundamental form matrix,
%       1 / det(PHI.Second_Fund_Form)).

% Copyright (c) 05-19-2016,  Shawn W. Walker

if ~isempty(obj.PHI.Det_Second_Fund_Form)
    obj.PHI.Inv_Det_Second_Fund_Form = sym('Inv_Det_Second_Fund_Form');
else
    obj.PHI.Inv_Det_Second_Fund_Form = [];
end

end