function [obj, New_GEOM, New_CF] =...
                  Convert_Expression_To_Interpolation_Routine(obj,sub_row,sub_col,GEOM,CF)
%Convert_Expression_To_Interpolation_Routine
%
%   This converts the symbolic expression into a FEM_Interpolate subroutine.
%   Note: this is only for a sub-interpolation of the overall interpolation.

% Copyright (c) 01-27-2014,  Shawn W. Walker

% get the code snippet
[New_GEOM, ~, New_CF, Ccode_Frag] = ...
    Convert_Symbolic_Expression_To_CPP_snippet(obj,obj.Expression(sub_row,sub_col),GEOM,[],CF);
%

% change the standard variable that matlab uses for the final output
Ccode_Frag(end).line = regexprep(Ccode_Frag(end).line, 't0', 'INTERP');
% create a "double" data type for each line (except the last)
for line_ind = 1:length(Ccode_Frag)-1
    Ccode_Frag(line_ind).line = ['double', Ccode_Frag(line_ind).line];
end

% store info on the SubINT and generate the evaluation code
obj = obj.Write_SubInterpolation_Computation(sub_row,sub_col,New_GEOM.DoI_Geom,Ccode_Frag);

end