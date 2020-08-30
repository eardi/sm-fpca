function [status, Path_To_Mex, Elems_DoF_Alloc] = Convert_Interp_Definition_to_MEX(Interp_Handle,Interp_Args,...
                                         MEX_FileName,MEX_Dir,Snippet_SubDir,GenCode_SubDir)
%Convert_Interp_Definition_to_MEX
%
%   Generic compile procedure for generating MEX files that interpolate FE
%   functions via FELICITY's code generation.
%
%   [status, Path_To_Mex, Elems_DoF_Alloc] = Convert_Interp_Definition_to_MEX(Interp_Handle);
%
%   inputs:
%   Interp_Handle = direct function handle to the interpolation definition
%                   m-file that defines the FE interpolations to perform;
%                   this is *not* an anonymous function handle.
%                   Example:  Interp_Handle = @InterpFE_Data;
%
%   outputs:
%   status      = success == 0 or failure ~= 0.
%   Path_To_Mex = (string) full path to the MEX file.
%                 Note: the MEX file will be put into the same directory as
%                 the m-file pointed to by 'Interp_Handle', with name given
%                 by 'mex_<name of interp. defn file>'.
%   Elems_DoF_Alloc = collection of finite element definition structs used
%                     for autogenerating mex files for DoF allocation.
%                     Note: this is used by the routine: "Create_DoF_Allocator".
%
%   [status, Path_To_Mex, Elems_DoF_Alloc] = Convert_Interp_Definition_to_MEX(Interp_Handle,Interp_Args);
%
%   similar to above, but:
%   inputs:
%   Interp_Args = cell array of input arguments to supply to 'Interp_Handle'.
%                 Note: if there are no arguments, then this should be
%                 omitted or set equal to an empty cell array.
%
%
%   [status, Path_To_Mex, Elems_DoF_Alloc] = Convert_Interp_Definition_to_MEX(...
%                                   Interp_Handle,Interp_Args,MEX_FileName);
%   similar to above, but:
%   inputs:
%   MEX_FileName = (string) desired name of the MEX file (without extension).
%                  If set to the empty matrix, then
%                  MEX_FileName := 'mex_<name of interp. defn file>'.
%
%
%   [status, Path_To_Mex, Elems_DoF_Alloc] = Convert_Interp_Definition_to_MEX(...
%                                   Interp_Handle,Interp_Args,MEX_FileName,MEX_Dir);
%   similar to above, but:
%   inputs:
%   MEX_Dir = (string) full directory in which to hold the MEX file.
%
%
%   [status, Path_To_Mex, Elems_DoF_Alloc] = Convert_Interp_Definition_to_MEX(Interp_Handle,Interp_Args,...
%                                   MEX_FileName,MEX_Dir,Snippet_SubDir,GenCode_SubDir);
%   similar to above, but:
%   inputs:
%   Snippet_SubDir = (string) name of sub-dir of the interp. definition file's
%                    directory to store temporary snippets of c-code.  If
%                    omitted, then the default sub-dir is 'Scratch_Dir'.
%   GenCode_SubDir = (string) name of sub-dir of the interp. definition file's
%                    directory to store the generated c++ code that
%                    implements the FE interpolation.  If omitted, then the
%                    default sub-dir is 'Interpolation_Code_AutoGen'.

% Copyright (c) 11-07-2017,  Shawn W. Walker

% make sure it is a proper function handle
FH_Info = functions(Interp_Handle);
if or(~strcmpi(FH_Info.type,'simple'),isempty(FH_Info.file))
    error('Function handle must *not* be anonymous!');
end
% get path!
Interp_Dir = fileparts(FH_Info.file);
FH_str = FH_Info.function;

% other error checking
if (nargin < 1)
    error('Not enough input arguments!');
end
if (nargin < 2)
    Interp_Args = {}; % assume no input arguments to Interp_Handle
end
if (nargin < 3)
    MEX_FileName = ['mex_', FH_str]; % default name
end
if (nargin < 4)
    MEX_Dir = Interp_Dir; % default to same dir as interpolation file
end
if (nargin < 5)
    Snippet_SubDir = 'Scratch_Dir'; % default name
end
if (nargin < 6)
    GenCode_SubDir = 'Interpolation_Code_AutoGen'; % default name
end

% make sure input arguments (for interpolation file) is in a cell array
if ~iscell(Interp_Args)
    error(['Input arguments to ''Interpolation'' File: ', FH_str, ', must be in a cell array!']);
end

% in case we want to supply MEX_dir only
if isempty(MEX_FileName)
    MEX_FileName = ['mex_', FH_str]; % default name
end
% other fail-safes
if isempty(MEX_Dir)
    MEX_Dir = Interp_Dir; % default to same dir as interpolation file
end
if isempty(Snippet_SubDir)
    Snippet_SubDir = 'Scratch_Dir'; % default name
end
if isempty(GenCode_SubDir)
    GenCode_SubDir = 'Interpolation_Code_AutoGen'; % default name
end

% generate and compile the code
FI = FELInterface(Interp_Dir);
[status, Path_To_Mex, Elems_DoF_Alloc] = FI.Compile_Interpolation_Code(Interp_Handle,Interp_Args,MEX_FileName,MEX_Dir,Snippet_SubDir,GenCode_SubDir);

end