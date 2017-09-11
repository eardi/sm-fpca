function S = Output_PHI_Struct(obj)
%Output_PHI_Struct
%
%   This outputs a struct variable whose fields are the same as obj.PHI.
%   Field values are initialized to ``false''.

% Copyright (c) 02-20-2012,  Shawn W. Walker

% get the field names
names = fieldnames(obj.PHI);
C = cell(length(names),1);
S = cell2struct(C, names, 1);
for ind=1:length(names)
    S.(names{ind}) = false;
end

end