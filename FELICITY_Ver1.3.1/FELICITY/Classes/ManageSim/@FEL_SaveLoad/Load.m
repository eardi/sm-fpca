function Data_Struct = Load(obj,Type_Str,Index)
%Load
%
%   Load the data.
%
%   Data_Struct = obj.Load(Type_Str,Index);
%
%   Data_Struct = struct containing the stuff you want to load.
%
%   Type_Str = 'static' or 'dynamic' to indicate if the data depends on an index.
%               Static data is saved in a single file; dynamic data is saved in a
%               specific file with a specific index.
%   Index    = index of filename to load (if data is 'dynamic').

% Copyright (c) 05-17-2019,  Shawn W. Walker

if and( (nargin==2), strcmpi(Type_Str,'dynamic') )
    error('Must supply an index if data is dynamic!');
end

if strcmpi(Type_Str,'static')
    FileName = obj.Make_FileName_Static();
elseif strcmpi(Type_Str,'dynamic')
    FileName = obj.Make_FileName(Index);
else
    error('Invalid type!  Must be ''static'' or ''dynamic''.');
end

Data_Struct = load(FileName);

end