function Is_Valid = Is_Valid_Dir(obj,Input_Dir)
%Is_Valid_Dir
%
%   Check that the given directory is a valid choice for a data directory.
%
%   Is_Valid = obj.Is_Valid_Dir(Input_Dir)
%
%   Input_Dir = (string) full path directory.
%
%   Is_Valid  = true if valid.

% Copyright (c) 01-30-2017,  Shawn W. Walker

Is_Valid = true;

Root_Only = obj.Check_Root_Dir(Input_Dir);
if Root_Only
    disp(['Given directory:  ', Input_Dir]);
    disp('The directory only consists of the root!');
    disp('The root directory cannot be a data directory!');
    Is_Valid = false;
end

end