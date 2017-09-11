function [obj, Spaces] = Set_Interpolation(obj,Spaces,sub_row,sub_col)
%Set_Interpolation
%
%   This sets up one of the sub-matrices.
%
%   INPUTS:
%   Spaces = array of FEM spaces (FELSpaces) that are used (remember, the
%            interpolation could involve functions from many different FEM
%            spaces).
%   sub_row,sub_col = row,col indices of the sub-interpolation to perform; this
%                     is because the interpolation could be vector or matrix
%                     valued.
%
%   OUTPUTS: they get modified by this routine, i.e. we keep track of what
%            quantities we need to compute (e.g. gradients of basis functions),
%            so that we can tell the code generator to create code to evaluate
%            those things.

% Copyright (c) 01-29-2013,  Shawn W. Walker

if or(sub_row > size(obj.SubINT,1),sub_col > size(obj.SubINT,2))
    error('Sub-interpolation index to large!');
end
% COMMENTS:
%
% What do you need to evaluate the interpolation?
% 1.  The domain.  You must know how it is parametrized.  You will need to pick
%     out the geometric function that parameterizes the domain of integration.
% 2.  All coefficient functions.  You must know what each is, and how it is
%     represented on the domain of expression, i.e. is the function's FEM space
%     defined on the domain of expression?  Or is the FEM space defined on a
%     domain that *contains* the domain of expression, which means we need to
%     restrict the function (take its trace) to the domain of expression.  Thus,
%     we need the geometric function that represents that (which may, in
%     general, be different from the geo. function that parameterizes the
%     domain).
% 3.  Any other extra geometric functions.  For example, you may want to *evaluate* the
%     normal vector of a surface on a curve embedded in the surface.  Thus, similar
%     considerations must be made as above.

% get the index (into Spaces.Integration(:)) of the Domain of Expression/Evaluation (DoE)
% for the particular interpolation we are dealing with
Integration_Index = Spaces.Get_Integration_Index(obj.Domain);

% get *all* geometric information to be evaluated on the Domain of Integration (DoI)
GEOM = obj.Get_Local_Geom_Functions(Spaces,Integration_Index);
% get any coefficient functions
CF   = obj.Get_Local_Coef_Functions(Spaces,Integration_Index);

[obj, New_GEOM, New_CF] = obj.Convert_Expression_To_Interpolation_Routine(sub_row,sub_col,GEOM,CF);

% we must update the finite element basis functions (in the appropriate spaces),
%    that are used by the coefficient functions, to reflect the required
%    derivative operations (on the appropriate domain) that the C++ code must
%    implement.
% Note: we don't need to keep track of what exactly was evaluated after this routine!
for ind = 1:length(New_CF)
    % Note: coefficient functions are defined in terms of their function spaces
    Spaces = Spaces.Update_Basis_Function_Option_In_Given_Space(New_CF(ind).Integration_Index,New_CF(ind).func);
end

% Note: we don't need to keep track of what exactly was evaluated after this routine!
Spaces = Spaces.Set_Coefficient_Options(New_CF);

Spaces = Spaces.Update_All_GeomFunc_Options(Integration_Index,New_GEOM);

% Spaces.Integration(1).DoI_Geom.Opt
% disp('*****************************************');

end