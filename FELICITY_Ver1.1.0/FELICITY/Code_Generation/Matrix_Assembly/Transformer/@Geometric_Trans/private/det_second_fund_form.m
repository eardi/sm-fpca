function obj = det_second_fund_form(obj)
%det_second_fund_form
%
%   Get the determinant of the second fundamental form matrix,
%           det(PHI.Second_Fund_Form)).

% Copyright (c) 02-20-2012,  Shawn W. Walker

if ~isempty(obj.PHI.Second_Fund_Form)
    obj.PHI.Det_Second_Fund_Form = sym('[Det_Second_Fund_Form]');
else
    obj.PHI.Det_Second_Fund_Form = [];
end

end