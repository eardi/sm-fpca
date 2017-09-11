function [DEFINES, ALIGNED] = Setup_Main_MEX_Input_DEFINES(obj,SPACE_LEN,mex_strings)
%Setup_Main_MEX_Input_DEFINES
%
%   This just generates #defines for passing in input arguments.

% Copyright (c) 01-29-2013,  Shawn W. Walker

%%%%%%%
% output text-lines
%%%DEFINES.INTERP.Points   = ['PRHS_', mex_strings.INTERP.Points];
DEFINES.MESH.Node_Value = ['PRHS_', mex_strings.MESH.Node_Value];
DEFINES.MESH.DoFmap     = ['PRHS_', mex_strings.MESH.DoFmap];
DEFINES.MESH.Orient     = ['PRHS_', mex_strings.MESH.Orient];

%%%ALIGNED.INTERP.Points   = [obj.Pad_With_Whitespace(DEFINES.INTERP.Points,  SPACE_LEN), ' ', num2str(0)];
ALIGNED.MESH.Node_Value = [obj.Pad_With_Whitespace(DEFINES.MESH.Node_Value,SPACE_LEN), ' ', num2str(0)];
ALIGNED.MESH.DoFmap     = [obj.Pad_With_Whitespace(DEFINES.MESH.DoFmap,    SPACE_LEN), ' ', num2str(1)];
ALIGNED.MESH.Orient     = [obj.Pad_With_Whitespace(DEFINES.MESH.Orient,    SPACE_LEN), ' ', num2str(2)];

DEFINES.MESH_SUBDOMAIN.Struct_List = ['PRHS_',mex_strings.MESH_SUBDOMAIN];
ALIGNED.MESH_SUBDOMAIN.Struct_List = [obj.Pad_With_Whitespace(DEFINES.MESH_SUBDOMAIN.Struct_List,    SPACE_LEN),...
                                      ' ', num2str(3)];
%

end