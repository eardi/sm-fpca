function Domain_Info = Setup_FELDomain(obj)
%Setup_FELDomain
%
%   This inits the FELDomain object.

% Copyright (c) 05-25-2012,  Shawn W. Walker

% get a struct that contains all (unique) information about the domains of
% integration, the global container, and any other needed embeddings
DS = Get_Unique_List_Of_Domains(obj);

for ind = 1:length(DS.Domain_Of_Integration)
    % add the number of quad points to use for the domain of integration
    NQ = Get_Num_Quad_Points_From_Quad_Order(obj.MATS.Quad_Order,DS.Domain_Of_Integration(ind).Domain.Type);
    DS.Domain_Of_Integration(ind).Num_Quad  = NQ;
    % set the integration domain geometry (i.e. codimension and curved-ness)
    DS.Domain_Of_Integration(ind).IS_CURVED = Set_Integration_Domain_Geometry(obj.MATS.GeoElem);
end
% error check
Check_Domains(obj,DS);

% loop through all the DoI's
Domain_Info = FELDomain(DS.Hold_All, DS.Hold_All, DS.Domain_Of_Integration(1).Domain,...
                        DS.Domain_Of_Integration(1).IS_CURVED,DS.Domain_Of_Integration(1).Num_Quad);
for ind = 2:length(DS.Domain_Of_Integration)
    Domain_Info(ind) = FELDomain(DS.Hold_All, DS.Hold_All, DS.Domain_Of_Integration(ind).Domain,...
                                 DS.Domain_Of_Integration(ind).IS_CURVED,DS.Domain_Of_Integration(ind).Num_Quad);
end

end