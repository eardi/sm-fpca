function obj = Delete_Subdomain(obj,SubName)
%Delete_Subdomain
%
%   This routine deletes the given subdomain from the mesh object.  In other
%   words, obj.Subdomain(k) will be deleted, where k is the corresponding array
%   index of the given subdomain.
%
%   obj = obj.Delete_Subdomain(SubName);
%
%   SubName = (string) name of the mesh subdomain.

% Copyright (c) 04-26-2013,  Shawn W. Walker

SUB_Index = obj.Get_Subdomain_Index(SubName);
if (SUB_Index==0)
    STR = ['This subdomain was not found: ''', SubName, '''!'];
    disp(STR);
    disp('     so there is nothing to delete!');
    error('Make sure you specified the correct subdomain!');
end

obj.Subdomain(SUB_Index) = []; % delete!

end