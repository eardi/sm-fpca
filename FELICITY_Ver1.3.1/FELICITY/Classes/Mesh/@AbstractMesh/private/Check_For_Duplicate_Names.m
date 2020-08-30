function status = Check_For_Duplicate_Names(obj,SubName)
%Check_For_Duplicate_Names
%
%   This routine checks if a sub-domain name is already in use.
%
%   status = obj.Check_For_Duplicate_Names(SubName)
%
%   SubName = (string) name of given sub-domain.

% Copyright (c) 02-20-2008,  Shawn W. Walker

% check for duplicate names
Sub_Index = obj.Get_Subdomain_Index(SubName);
if (Sub_Index > 0)
    disp(['ERROR: There is already a subdomain with Name: ', SubName]);
    error('You must use distinct Names!');
elseif strcmp(SubName,obj.Name)
    disp(['ERROR: You cannot name the subdomain the *same* as the underlying mesh!']);
    error('You must use distinct Names!');
end

status = 0;

end