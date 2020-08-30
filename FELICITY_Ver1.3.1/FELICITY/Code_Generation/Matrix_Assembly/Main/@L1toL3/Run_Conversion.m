function [FS, FM, C_Codes, Elems_DoF_Allocation] = Run_Conversion(obj,Main_Dir,Snippet_Dir)
%Run_Conversion
%
%   This converts MATS (a Level 1 object) into Level 3 objects.
%   Note: there is an intermediate Level 2 object (struct).

% Copyright (c) 11-07-2017,  Shawn W. Walker

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

% get collection of Finite Element Definition structs needed for generating
% automatic DoF allocation mex files
Elems_DoF_Allocation = FE_Space_Info_For_DoF_Allocation(obj.MATS);

end

function ELEMS = FE_Space_Info_For_DoF_Allocation(MATS)

ELEMS = containers.Map; % init

Num_Matrix_Data = length(MATS.Matrix_Data);
for ii = 1:Num_Matrix_Data
    % get current matrix
    MD = MATS.Matrix_Data{ii}(1); % only 1 is needed, b/c space is the same
    
    if ~isempty(MD.Test_Space)
        % get the corresponding element
        FE_Space_Name = MD.Test_Space.Name;
        Elem = MD.Test_Space.Elem;
        % only include the FE space if it is *not* a global constant
        if ~strcmp(Elem.Transformation,'Constant_Trans')
            ELEMS(FE_Space_Name) = Elem;
        end
    end
    if ~isempty(MD.Trial_Space)
        % get the corresponding element
        FE_Space_Name = MD.Trial_Space.Name;
        Elem = MD.Trial_Space.Elem;
        % only include the FE space if it is *not* a global constant
        if ~strcmp(Elem.Transformation,'Constant_Trans')
            ELEMS(FE_Space_Name) = Elem;
        end
    end
    % don't forget to add in any Coef FE spaces
    % loop through the integrals
    for rr = 1:length(MD.Integral)
        Current_Integral = MD.Integral(rr);
        if ~isempty(Current_Integral.CoefF)
            % loop through all CoefF's
            for kk = 1:length(MD.Integral.CoefF)
                Specific_CoefF = MD.Integral.CoefF(kk);
                % get the corresponding element
                FE_Space_Name = Specific_CoefF.Element.Name;
                Elem = Specific_CoefF.Element.Elem;
                % only include the FE space if it is *not* a global constant
                if ~strcmp(Elem.Transformation,'Constant_Trans')
                    ELEMS(FE_Space_Name) = Elem;
                end
            end
        end
    end
end

% add in geometry
ELEMS(MATS.GeoElem.Name) = MATS.GeoElem.Elem;

end