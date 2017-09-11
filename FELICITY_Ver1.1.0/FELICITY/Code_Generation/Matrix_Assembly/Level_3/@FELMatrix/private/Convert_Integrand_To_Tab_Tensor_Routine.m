function [obj, New_GEOM, New_BF, New_CF] =...
                  Convert_Integrand_To_Tab_Tensor_Routine(obj,SM,GEOM,BF,CF)
%Convert_Integrand_To_Tab_Tensor_Routine
%
%   This converts the symbolic integrand into a Tabulate_Tensor subroutine.
%   Note: this is only for a sub-matrix of the (block) FE matrix.

% Copyright (c) 01-24-2014,  Shawn W. Walker

% get the code snippet
[New_GEOM, New_BF, New_CF, Ccode_Frag] = ...
    Convert_Symbolic_Expression_To_CPP_snippet(obj,SM.Sym_Integrand,GEOM,BF,CF);
%

% change the standard variable that matlab uses for the final output
Ccode_Frag(end).line = regexprep(Ccode_Frag(end).line, 't0', 'integrand');
% create a "double" data type for each line!
for line_ind = 1:length(Ccode_Frag)
    Ccode_Frag(line_ind).line = ['double', Ccode_Frag(line_ind).line];
end

% you always need the quad weighted jacobian for the intrinsic geometry
New_GEOM.DoI_Geom.Opt.Det_Jacobian_with_quad_weight = true;

% store info on the SubMAT and generate the evaluation code
obj = obj.Write_SubMatrix_Computation(SM,New_GEOM.DoI_Geom,New_BF,Ccode_Frag);

end