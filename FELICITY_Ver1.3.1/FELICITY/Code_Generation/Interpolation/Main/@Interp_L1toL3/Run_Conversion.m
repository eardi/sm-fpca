function [FS, FI, C_Codes, Elems_DoF_Allocation] = Run_Conversion(obj,Main_Dir,Snippet_Dir)
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

% get collection of Finite Element Definition structs needed for generating
% automatic DoF allocation mex files
Elems_DoF_Allocation = FE_Space_Info_For_DoF_Allocation(obj.INTERP);

end

function ELEMS = FE_Space_Info_For_DoF_Allocation(INTERP)

ELEMS = containers.Map; % init

Num_Interp_Expr = length(INTERP.Interp_Expr);
for ii = 1:Num_Interp_Expr
    % get current interpolation
    IE = INTERP.Interp_Expr{ii};
    if ~isempty(IE.CoefF)
        % loop through all CoefF's
        for kk = 1:length(IE.CoefF)
            Specific_CoefF = IE.CoefF(kk);
            % get the corresponding element
            FE_Space_Name = Specific_CoefF.Element.Name;
            Elem = Specific_CoefF.Element.Elem;
            % only include the FE space if it is *not* a global constant
            if ~strcmp(Elem.Transformation,'Constant_Trans')
                ELEMS(FE_Space_Name) = Elem;
            end
        end
    end
    % below is not needed...
%     if ~isempty(IE.GeoF)
%         % get current element
%         % REMOVE?
%         ELEMS(IE.GeoF.Name) = IE.GeoF.Elem;
%     end
end

% add in geometry
ELEMS(INTERP.GeoElem.Name) = INTERP.GeoElem.Elem;

end