function [FS, FI, C_Codes] = Run_Conversion(obj,Main_Dir,Snippet_Dir)
%Run_Conversion
%
%   This converts INTERP (a Level 1 object) into Level 3 objects.
%   Note: there is an intermediate Level 2 object (struct).

% Copyright (c) 01-25-2013,  Shawn W. Walker

Domain_of_Expression_Info = obj.Setup_FELDomain;

% create an array of special basis function objects that know nothing about the
% global FE space except for its NAME; just local info (like the reference
% element).  This array of objects will be stored within FELSpaces...

FS = obj.Setup_FELSpaces(Domain_of_Expression_Info);
% FELSpace contains one single set of FE spaces and an array of
% Integration_Domains (expression domains).  For each Integration_Domain, a set
% of basis functions is stored that corresponds to the set of FE spaces.  In addition,
% any coefficient functions, and extra geometric functions, are also stored in each
% Integration_Domain.

[FS, FI] = obj.Init_FELInterpolations(FS,Snippet_Dir);

% remove the parts of the FELSpaces that are not used!
FS = obj.Prune_BasisFunc(FS);

C_Codes = obj.Setup_C_Codes(Main_Dir);

end