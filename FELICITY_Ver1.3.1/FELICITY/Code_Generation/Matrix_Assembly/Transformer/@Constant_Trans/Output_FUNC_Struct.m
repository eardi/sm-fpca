function SS = Output_FUNC_Struct(obj)
%Output_FUNC_Struct
%
%   This outputs a struct variable whose fields are the same as obj.C.
%   Field values are initialized to ``false''.

% Copyright (c) 01-11-2018,  Shawn W. Walker

% get the field names
names = fieldnames(obj.C);
CL = cell(length(names),1);
SS = cell2struct(CL, names, 1);
for ind=1:length(names)
    SS.(names{ind}) = false;
end

end