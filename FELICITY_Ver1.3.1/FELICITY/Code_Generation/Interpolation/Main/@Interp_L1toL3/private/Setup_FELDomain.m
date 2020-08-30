function Domain_Info = Setup_FELDomain(obj)
%Setup_FELDomain
%
%   This inits the FELDomain object.

% Copyright (c) 01-28-2013,  Shawn W. Walker

% get a struct that contains all (unique) information about the domains of
% expressions, the global container, and any other needed embeddings
DS = Get_Unique_List_Of_Domains(obj);

for ind = 1:length(DS.Domain_Of_Expression)
    DS.Domain_Of_Expression(ind).Num_Quad  = 1; % SWW: this will be removed...
    % set the expression domain geometry (i.e. codimension and curved-ness)
    DS.Domain_Of_Expression(ind).IS_CURVED = Set_Expression_Domain_Geometry(obj.INTERP.GeoElem);
end
% error check
Check_Domains(obj,DS);

% loop through all the DoI's
Domain_Info = FELDomain(DS.Hold_All, DS.Hold_All, DS.Domain_Of_Expression(1).Domain,...
                        DS.Domain_Of_Expression(1).IS_CURVED,DS.Domain_Of_Expression(1).Num_Quad);
for ind = 2:length(DS.Domain_Of_Expression)
    Domain_Info(ind) = FELDomain(DS.Hold_All, DS.Hold_All, DS.Domain_Of_Expression(ind).Domain,...
                                 DS.Domain_Of_Expression(ind).IS_CURVED,DS.Domain_Of_Expression(ind).Num_Quad);
end

end