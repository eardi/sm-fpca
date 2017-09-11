function FUNC = Set_Evaluation_Domain_Of_Functions(obj,FUNC)
%Set_Evaluation_Domain_Of_Functions
%
%   This sets the domain of evaluation of all the functions to be the domain of
%   expression.
%
%   FUNC = obj.Set_Evaluation_Domain_Of_Functions(FUNC);
%
%   FUNC = cell array of Level 1 Test, Trial, and Coef(s).
%
%   Output is similar, except the Domain restriction of the function is set to
%          be the Domain of the abstract expression (i.e. obj.Domain).

% Copyright (c) 06-23-2012,  Shawn W. Walker

Expression_Domain = obj.Domain;

for ind = 1:length(FUNC)
    if isempty(FUNC{ind}.Domain)
        FUNC{ind}.Domain = Expression_Domain;
    end
end

end