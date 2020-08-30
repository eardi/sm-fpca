function [FPS, BLANK, C_Codes, BLANK_Extra] = Run_Conversion(obj,Main_Dir,Snippet_Dir)
%Run_Conversion
%
%   This converts PTSEARCH (a Level 1 object) into Level 3 objects.
%   Note: there is an intermediate Level 2 object (struct).

% Copyright (c) 06-13-2014,  Shawn W. Walker

Search_Domain = obj.Setup_FELDomain;

% create a geometric element for the Hold-All container domain
DEBUG = true;
Geom_Elem = ReferenceFiniteElement(obj.PTSEARCH.GeoElem.Elem,DEBUG);
%obj.PTSEARCH.GeoElem.Tensor_Comp

FPS = FELPointSearches(Geom_Elem,Search_Domain);

BLANK = [];

%C_Codes = obj.Setup_C_Codes(Main_Dir);
C_Codes.FileName = [];

BLANK_Extra = [];

end