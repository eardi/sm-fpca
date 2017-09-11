function [obj, Spaces] = Set_Sub_Matrix(obj,SM,Spaces)
%Set_Sub_Matrix
%
%   This sets up one of the sub-matrices.
%
%   INPUTS:
%   SM.Domain      = Level 1 Domain of integration.
%   SM.Sub_Ind     = index to which sub-matrix we are setting (e.g. a 2-D vector
%                    mass matrix will have 4 sub-matrices (1,2,3,4)).
%   SM.vector_SubMAT_index = vector block matrix index (e.g. (1,2) is the first
%                            ``row'', second ``column'' of the block matrix).
%   SM.COPY_SubMAT = struct containing info about whether to just copy another
%                    sub-matrix over (e.g. a 2-D vector mass matrix will only
%                    have 2 non-zero block-matrices (1,1), (2,2) and we don't
%                    need to recompute the (2,2) block b/c we can just copy the
%                    (1,1) block over).
%   SM.Sym_Integrand = symbolic representation of the integrand; we will do
%                      string replacements here in the code below.
%
%   Spaces = array of FEM spaces (FELSpaces) that are used (remember, the
%            integrand could involve functions from many different FEM spaces).
%   OUTPUTS: they get modified by this routine, i.e. we keep track of what
%            quantities we need to compute (e.g. gradients of basis functions),
%            so that we can tell the code generator to create code to evaluate
%            those things.

% Copyright (c) 06-03-2012,  Shawn W. Walker

if (SM.Sub_Ind > obj.Num_SubMAT)
    error('Sub-Matrix index to large!');
end
% COMMENTS:
%
% What do you need to evaluate the integral?
% 1.  The domain.  You must know how it is parametrized.  You will need to pick
%     out the geometric function that parameterizes the domain of integration.
% 2.  The test function.  You must know what it is, and how it is represented on
%     the domain of integration, i.e. is the function's FEM space defined on the
%     domain of integration?  Or is the FEM space defined on a domain that
%     *contains* the domain of integration, which means we need to restrict the
%     function (take its trace) to the domain of integration.  Thus, we need the
%     geometric function that represents that (which may, in general, be
%     different from the geo. function that parameterizes the domain).
% 3.  The trial function.  Similar as above.
% 4.  All coefficient functions.  Also similar as above.
% 5.  Any other extra geometric functions.  For example, you may want to *evaluate* the
%     normal vector of a surface on a curve embedded in the surface.  Thus, similar
%     considerations must be made as above.

% get the index (into Spaces.Integration(:)) of the Domain of Integration (DoI) for the
% particular sub-matrix we are dealing with
Integration_Index = Spaces.Get_Integration_Index(SM.Domain);

% get *all* geometric information to be evaluated on the Domain of Integration (DoI)
GEOM = obj.Get_Local_Geom_Functions(Spaces,Integration_Index);
% get basis functions and any coefficient functions
BF   = obj.Get_Local_Basis_Functions(Integration_Index);
CF   = obj.Get_Local_Coef_Functions(Spaces,Integration_Index);

[obj, New_GEOM, New_BF, New_CF] = obj.Convert_Integrand_To_Tab_Tensor_Routine(SM,GEOM,BF,CF);

% we must update the finite element basis functions (in the appropriate spaces)
% to reflect the required derivative operations (on the appropriate domain) that
% the C++ code must implement.
% Note: we don't need to keep track of what exactly was evaluated after this routine!
Spaces = Spaces.Update_Basis_Function_Options(New_BF,New_CF);

% Note: we don't need to keep track of what exactly was evaluated after this routine!
Spaces = Spaces.Set_Coefficient_Options(New_CF);

Spaces = Spaces.Update_All_GeomFunc_Options(Integration_Index,New_GEOM);

% Spaces.Integration(1).DoI_Geom.Opt
% disp('*****************************************');

end