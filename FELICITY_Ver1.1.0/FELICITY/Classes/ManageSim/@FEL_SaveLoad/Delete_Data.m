function Delete_Data(obj,Type_Str,IND)
%Delete_Data
%
%   This deletes files in the obj.Data_Dir directory.
%
%   If you want to delete all of the data, then run:  obj.Delete_Data();
%
%   If you want to delete the static data:  obj.Delete_Data('static');
%
%   If you want to delete specific dynamic data:
%
%   obj.Delete_Data('dynamic',IND);
%
%   where IND = vector of indices corresponding to the files to delete.

% Copyright (c) 05-11-2015,  Shawn W. Walker

if nargin==1
    File_Del = FELtest('Clear out old data');
    File_Del.Delete_Files_In_Dir(obj.Data_Dir);
elseif nargin==2
    if strcmpi(Type_Str,'static')
        FileName = obj.Make_FileName_Static();
        % delete the file
        delete(FileName);
    elseif strcmpi(Type_Str,'dynamic')
        error('Must supply additional argument containing file indices for dynamic data.');
    else
        error('Invalid parameter!  Must be ''static'' or ''dynamic''.');
    end
elseif nargin==3
    IND = sort(IND);
    if strcmpi(Type_Str,'dynamic')
        if min(IND) < 0
            error('File indices must be >= 0!');
        end
        % remove indices that are above max
        mask = IND > obj.Get_Max_Index;
        IND(mask) = [];
        % loop thru the desired files
        for ii = 1:length(IND)
            Index = IND(ii);
            FileName = obj.Make_FileName(Index);
            % delete the file
            delete(FileName);
        end
    else
        error('Invalid parameter!  Must be ''static'' or ''dynamic''.');
    end
else
    error('Invalid number of parameters!');
end

end