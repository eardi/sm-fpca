function [FS, FM, C_Codes] = Run_Conversion(obj,Main_Dir,Snippet_Dir)
%Run_Conversion
%
%   This converts MATS (a Level 1 object) into Level 3 objects.
%   Note: there is an intermediate Level 2 object (struct).

% Copyright (c) 05-29-2012,  Shawn W. Walker

Domain_of_Integration_Info = obj.Setup_FELDomain;

% create an array of special basis function objects that know nothing about the
% global FE space except for its NAME; just local info (like the reference
% element).  This array of objects will be stored within FELSpaces...

FS = obj.Setup_FELSpaces(Domain_of_Integration_Info);
% FELSpace contains one single set of FE spaces and an array of
% Integration_Domains.  For each Integration_Domain, a set of basis functions is
% stored that corresponds to the set of FE spaces.  In addition, any coefficient
% functions, and extra geometric functions, are also stored in each Integration_Domain.

[FM, Matrix_Parsed] = obj.Init_FELMatrices(FS,Snippet_Dir);
% Note: Matrix_Parsed is a Level 2 object/struct.

[FS, FM] = obj.Define_FELMatrices(FS,FM,Matrix_Parsed);

% remove the parts of the FELSpaces that are not used!
FS = obj.Prune_BasisFunc(FS,FM);

C_Codes = obj.Setup_C_Codes(Main_Dir);

end