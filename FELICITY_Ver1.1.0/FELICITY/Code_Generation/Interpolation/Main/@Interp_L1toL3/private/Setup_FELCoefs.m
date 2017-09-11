function FS = Setup_FELCoefs(obj,FS)
%Setup_FELCoefs
%
%   This inits the CoefFunc Map container under FS.Integration.CoefFunc.

% Copyright (c) 01-28-2013,  Shawn W. Walker

Num_Distinct_Expression_Domains = length(FS.Integration);
for ind = 1:Num_Distinct_Expression_Domains
    Current_Expression_Domain = FS.Integration(ind).DoI_Geom.Domain.Integration_Domain;
    % look thru all the matrices
    Num_Expr = length(obj.INTERP.Interp_Expr);
    
    for ie = 1:Num_Expr
        %ID = obj.MATS.Matrix_Data{mi}.Integral;
        I_Expr = obj.INTERP.Interp_Expr{ie};
        
        % if the expression domain matches the current Expression_Domain
        if isequal(I_Expr.Domain,Current_Expression_Domain)
            % include any coefficient functions
            for ci = 1:length(I_Expr.CoefF)
                % get the defining terms
                Space_Name = I_Expr.CoefF(ci).Element.Name;
                RefElem = FS.Space(Space_Name).Elem;
                Func_Name_str = I_Expr.CoefF(ci).Name;
                % use the GeomFunc for the corresponding basis function
                GeomFunc = FS.Integration(ind).BasisFunc(Space_Name).GeomFunc;
                % create the object
                CF = FiniteElementCoefFunction(Space_Name,RefElem,Func_Name_str,GeomFunc);
                FS.Integration(ind).CoefFunc(CF.Func_Name) = CF; % insert!
            end
        end
    end
end

% note: don't worry if a FiniteElementCoefFunction gets overwritten; they are
% all on the same domain!

end