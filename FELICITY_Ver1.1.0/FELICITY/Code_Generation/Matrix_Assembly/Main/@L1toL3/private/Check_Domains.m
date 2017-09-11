function status = Check_Domains(obj,DS)
%Check_Domains
%
%   This just does some basic error checking.

% Copyright (c) 05-25-2012,  Shawn W. Walker

status = 0;

% check hold-all domain
if ~isequal(DS.Hold_All,obj.MATS.GeoElem.Domain)
    disp('Data structures are inconsistent!');
    error('This should not happen.  Please report this bug!');
end

Num_Domains = length(DS.Domain_Of_Integration);
for ind = 1:Num_Domains
    
    DoI = DS.Domain_Of_Integration(ind);
    if strcmp(DoI.Domain.Name,DoI.Domain.Subset_Of)
        disp(['ERROR: Domain of Integration: ', DoI.Domain.Name]);
        error('Domain of Integration cannot be a subset of itself!');
    end
    
    sbr_check_domain(DoI.Domain,DS.Hold_All);
    % check all embeddings domains
    for ee=1:length(DoI.Embeddings)
        sbr_check_domain(DoI.Embeddings(ee),DS.Hold_All);
    end
end

end

function sbr_check_domain(Domain,Hold_All)

% check that the domain is a subset of the Hold_All domain
if ~or(strcmp(Domain.Name,Hold_All.Name),strcmp(Domain.Subset_Of,Hold_All.Name))
    disp(['ERROR: problem with this Domain: ', Domain.Name]);
    disp(['ERROR: it is not equal to the hold-all domain: ', Hold_All.Name]);
    disp(['ERROR: AND it is not a *subset* of the hold-all domain.']);
    error('ERROR: check your Domain definitions!');
end

end