function FS = Setup_FELCoefs(obj,FS)
%Setup_FELCoefs
%
%   This inits the CoefFunc Map container under FS.Integration.CoefFunc.

% Copyright (c) 08-12-2014,  Shawn W. Walker

Num_Distinct_Integration_Domains = length(FS.Integration);
for ind = 1:Num_Distinct_Integration_Domains
    Current_Integration_Domain = FS.Integration(ind).DoI_Geom.Domain.Integration_Domain;
    % look thru all the matrices
    Num_Matrix = length(obj.MATS.Matrix_Data);
    for mi = 1:Num_Matrix
        MD = obj.MATS.Matrix_Data{mi};
        [nr, nc] = size(MD);
        % look thru all the sub-components of the matrix
        for rr = 1:nr
            for cc = 1:nc
                ID = MD(rr,cc).Integral;
                % search the integrals!
                for kk = 1:length(ID)
                    % if the integral domain matches the current Integration_Domain
                    if isequal(ID(kk).Domain,Current_Integration_Domain)
                        % include any coefficient functions
                        for ci = 1:length(ID(kk).CoefF)
                            % get the defining terms
                            Space_Name = ID(kk).CoefF(ci).Element.Name;
                            RefElem = FS.Space(Space_Name).Elem;
                            Func_Name_str = ID(kk).CoefF(ci).Name;
                            % use the GeomFunc for the corresponding basis function
                            GeomFunc = FS.Integration(ind).BasisFunc(Space_Name).GeomFunc;
                            % create the object
                            CF = FiniteElementCoefFunction(Space_Name,RefElem,Func_Name_str,GeomFunc);
                            FS.Integration(ind).CoefFunc(CF.Func_Name) = CF; % insert!
                        end
                    end
                end
            end
        end 
    end
end

% note: don't worry if a FiniteElementCoefFunction gets overwritten; they are
% all on the same domain!

end