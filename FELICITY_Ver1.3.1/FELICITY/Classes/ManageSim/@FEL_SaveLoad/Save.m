function Save(obj,Type_Str,Data_Struct,Index)
%Save
%
%   Save the data.
%
%   obj.Save(Type_Str,Data_Struct,Index);
%
%   Type_Str    = 'static' or 'dynamic' to indicate if the data depends on an index.
%                  Static data is saved in a single file; dynamic data is saved in a
%                  specific file with a specific index.
%   Data_Struct = struct (or object) containing the stuff you want to save.
%   Index       = index of filename to save it under (if data is 'dynamic').

% Copyright (c) 05-17-2019,  Shawn W. Walker

if and( (nargin==3), strcmpi(Type_Str,'dynamic') )
    error('Must supply an index if data is dynamic!');
end

if strcmpi(Type_Str,'static')
    FileName = obj.Make_FileName_Static();
elseif strcmpi(Type_Str,'dynamic')
    FileName = obj.Make_FileName(Index);
else
    error('Invalid type!  Must be ''static'' or ''dynamic''.');
end

save(FileName, '-struct', 'Data_Struct');

end