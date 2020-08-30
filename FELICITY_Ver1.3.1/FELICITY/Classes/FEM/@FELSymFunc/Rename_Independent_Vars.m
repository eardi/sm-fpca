function obj = Rename_Independent_Vars(obj,Old_Vars,New_Vars)
%Rename_Independent_Vars
%
%   This renames the independent variables (i.e. obj.Vars).
%
%   obj = obj.Rename_Independent_Vars(Old_Vars,New_Vars)
%
%   Old_Vars, New_Vars = 1xN cell arrays of names (strings) of independent
%                        variables. Old must match what is in the function
%                        already; New are the new variable names.

% Copyright (c) 10-31-2016,  Shawn W. Walker

% make sure the independent variable names are distinct between the two
% functions
Convert_to_String = @(F) char(F);
oV = cellfun(Convert_to_String, obj.Vars, 'UniformOutput', false);
CHK1 = setdiff(oV,Old_Vars);
if ~and(isempty(CHK1),(length(Old_Vars)==obj.input_dim))
    error('Old independent variables must match what the function already has!');
end
% make sure number of new equals number of old
if (length(Old_Vars)~=length(New_Vars))
    error('Number of variables not the same!');
end

TEMP = obj.Func; % init
for ind = 1:obj.input_dim
    TEMP = obj.subs_H(TEMP,Old_Vars{ind},New_Vars{ind});
end
if ~isa(TEMP,'sym')
    TEMP = sym(TEMP); % this needs to be done if TEMP is a constant
end

obj = FELSymFunc(TEMP,New_Vars);

end