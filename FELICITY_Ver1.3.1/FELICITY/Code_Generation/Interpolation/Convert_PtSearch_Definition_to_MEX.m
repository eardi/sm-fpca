function [status, Path_To_Mex] = Convert_PtSearch_Definition_to_MEX(Search_Handle,Search_Args,...
                                         MEX_FileName,MEX_Dir,GenCode_SubDir)
%Convert_PtSearch_Definition_to_MEX
%
%   Generic compile procedure for generating MEX files that perform point searches of
%   meshes via FELICITY's code generation.
%
%   [status, Path_To_Mex] = Convert_PtSearch_Definition_to_MEX(Search_Handle);
%
%   inputs:
%   Search_Handle = direct function handle to the point search definition
%                   m-file that defines the type of mesh to search;
%                   this is *not* an anonymous function handle.
%                   Example:  Search_Handle = @Search_Triangle_Mesh;
%
%   outputs:
%   status      = success == 0 or failure ~= 0.
%   Path_To_Mex = (string) full path to the MEX file.
%                 Note: the MEX file will be put into the same directory as
%                 the m-file pointed to by 'Search_Handle', with name given
%                 by 'mex_<name of pt. search defn file>'.
%
%
%   [status, Path_To_Mex] = Convert_PtSearch_Definition_to_MEX(Search_Handle,Search_Args);
%
%   similar to above, but:
%   inputs:
%   Search_Args = cell array of input arguments to supply to 'Search_Handle'.
%                 Note: if there are no arguments, then this should be
%                 omitted or set equal to an empty cell array.
%
%
%   [status, Path_To_Mex] = Convert_PtSearch_Definition_to_MEX(...
%                                   Search_Handle,Search_Args,MEX_FileName);
%   similar to above, but:
%   inputs:
%   MEX_FileName = (string) desired name of the MEX file (without extension).
%                  If set to the empty matrix, then
%                  MEX_FileName := 'mex_<name of pt. search defn file>'.
%
%
%   [status, Path_To_Mex] = Convert_PtSearch_Definition_to_MEX(...
%                                   Search_Handle,Search_Args,MEX_FileName,MEX_Dir);
%   similar to above, but:
%   inputs:
%   MEX_Dir = (string) full directory in which to hold the MEX file.
%
%
%   [status, Path_To_Mex] = Convert_PtSearch_Definition_to_MEX(Search_Handle,Search_Args,...
%                                   MEX_FileName,MEX_Dir,GenCode_SubDir);
%   similar to above, but:
%   inputs:
%   GenCode_SubDir = (string) name of sub-dir of the pt. search definition file's
%                    directory to store the generated c++ code that
%                    implements the mesh pt. search.  If omitted, then the
%                    default sub-dir is 'Pt_Search_Code_AutoGen'.

% Copyright (c) 03-31-2017,  Shawn W. Walker

% make sure it is a proper function handle
FH_Info = functions(Search_Handle);
if or(~strcmpi(FH_Info.type,'simple'),isempty(FH_Info.file))
    error('Function handle must *not* be anonymous!');
end
% get path!
Search_Dir = fileparts(FH_Info.file);
FH_str = FH_Info.function;

% other error checking
if (nargin < 1)
    error('Not enough input arguments!');
end
if (nargin < 2)
    Search_Args = {}; % assume no input arguments to Search_Handle
end
if (nargin < 3)
    MEX_FileName = ['mex_', FH_str]; % default name
end
if (nargin < 4)
    MEX_Dir = Search_Dir; % default to same dir as pt. search file
end
if (nargin < 5)
    GenCode_SubDir = 'Pt_Search_Code_AutoGen'; % default name
end

% make sure input arguments (for pt. search file) is in a cell array
if ~iscell(Search_Args)
    error(['Input arguments to ''Pt. Search'' File: ', FH_str, ', must be in a cell array!']);
end

% in case we want to supply MEX_dir only
if isempty(MEX_FileName)
    MEX_FileName = ['mex_', FH_str]; % default name
end
% other fail-safes
if isempty(MEX_Dir)
    MEX_Dir = Search_Dir; % default to same dir as pt. search file
end
if isempty(GenCode_SubDir)
    GenCode_SubDir = 'Pt_Search_Code_AutoGen'; % default name
end

% generate and compile the code
FI = FELInterface(Search_Dir);
[status, Path_To_Mex] = FI.Compile_Point_Search_Code(Search_Handle,Search_Args,MEX_FileName,MEX_Dir,GenCode_SubDir);

end