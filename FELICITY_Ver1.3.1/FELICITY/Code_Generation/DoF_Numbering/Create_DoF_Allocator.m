function [status, Path_To_Mex] = Create_DoF_Allocator(Elem,ARG2,ARG3,ARG4)
%Create_DoF_Allocator
%
%   Generic compile procedure for generating MEX files that allocate DoFs for
%   given finite element spaces via FELICITY's code generation.
%
%   [status, Path_To_Mex] = Create_DoF_Allocator(Elem_Collection,MEX_Prefix,MEX_Dir,GenCode_SubDir);
%
%   Note:  at least the first 3 arguments must be given.
%
%   Inputs:
%   Elem_Collection = a containers.Map object containing multiple finite
%                     element space information; this comes from running
%                     "Convert_Form_Definition_to_MEX".
%   MEX_Prefix     = (string) prefix to give each MEX file. If set to [],
%                    then the default string 'mex_DoF_Allocator' is used.
%   MEX_Dir        = (string) contains full path to the location of the MEX file.
%   GenCode_SubDir = (string) name of sub-dir of MEX_Dir to store the
%                    generated c++ code that implements the DoF allocator.
%                    If omitted, then the default sub-dir is
%                    'AutoGen_DoFNumbering'.
%
%   [status, Path_To_Mex] = Create_DoF_Allocator(Elem,MEX_FileName,MEX_Dir,GenCode_SubDir);
%
%   Inputs:
%   Elem         = array of element structs (as in the ./FELICITY/Elem_Defn
%                  directory) that represent the finite element spaces we want
%                  to allocate DoFs for.  Note: all must be defined on
%                  the same domain!
%   MEX_FileName = (string) full name to give MEX file.
%   MEX_Dir      = (string) same as previous.
%   GenCode_SubDir = (string) same as previous.
%
%   Outputs:
%   status       = success == 0 or failure ~= 0.
%   Path_To_Mex  = (string) full path to the MEX file.

% Copyright (c) 11-07-2017,  Shawn W. Walker

% error check Elem!

% determine which function call is being made
if isa(Elem,'containers.Map')
    % use the first call
    
    % other error checking
    if (nargin < 3)
        error('Not enough input arguments!');
    end
    % set filename prefix
    if isempty(ARG2)
        MEX_FileName = 'mex_DoF_Allocator'; % default name (prefix)
    else
        MEX_FileName = ARG2;
    end
    % get the directory
    MEX_Dir = ARG3;
    
    if (nargin < 4)
        GenCode_SubDir = 'AutoGen_DoFNumbering'; % default name
    else
        GenCode_SubDir = ARG4;
    end
    
    % generate and compile the code
    FI = FELInterface(MEX_Dir);
    % loop through elements
    FE_Space_Names = Elem.keys;
    for ii = 1:length(FE_Space_Names)
        Current_Elem = Elem(FE_Space_Names{ii});
        Current_FileName = [MEX_FileName, '_', FE_Space_Names{ii}];
%         disp('+++++++++++++++++++++++++++++++++++++++++++++++++++');
%         Current_Elem
%         Current_FileName
%         disp('+++++++++++++++++++++++++++++++++++++++++++++++++++');
        [status, Path_To_Mex] = FI.Compile_DoF_Numbering(Current_Elem,Current_FileName,MEX_Dir,GenCode_SubDir);
    end
else
    % the second call is being made
    
    % other error checking
    if (nargin < 3)
        error('Not enough input arguments!');
    end
    if (nargin < 4)
        GenCode_SubDir = 'AutoGen_DoFNumbering'; % default name
    else
        GenCode_SubDir = ARG4;
    end
    
    % pass inputs through
    MEX_FileName = ARG2;
    MEX_Dir = ARG3;
    
    % generate and compile the code
    FI = FELInterface(MEX_Dir);
    [status, Path_To_Mex] = FI.Compile_DoF_Numbering(Elem,MEX_FileName,MEX_Dir,GenCode_SubDir);
end

end