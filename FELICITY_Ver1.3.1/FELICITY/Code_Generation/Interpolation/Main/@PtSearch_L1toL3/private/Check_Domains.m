function status = Check_Domains(obj,DS)
%Check_Domains
%
%   This just does some basic error checking.

% Copyright (c) 06-13-2014,  Shawn W. Walker

status = 0;

% check hold-all domain
if ~isequal(DS.Hold_All,obj.PTSEARCH.GeoElem.Domain)
    disp('Data structures are inconsistent!');
    error('This should not happen.  Please report this bug!');
end

Num_Domains = length(DS.Domain_Of_Expression);
for ind = 1:Num_Domains
    
    DoE = DS.Domain_Of_Expression(ind);
    if strcmp(DoE.Domain.Name,DoE.Domain.Subset_Of)
        disp(['ERROR: Domain of Expression: ', DoE.Domain.Name]);
        error('Domain of Expression cannot be a subset of itself!');
    end
    
    sbr_check_domain(DoE.Domain,DS.Hold_All);
end

end

function sbr_check_domain(Domain,Hold_All)

% check that the domain is a subset of the Hold_All domain
if ~or(strcmp(Domain.Name,Hold_All.Name),strcmp(Domain.Subset_Of,Hold_All.Name))
    disp(['ERROR: there is a problem with this Domain: ', Domain.Name]);
    disp(['ERROR: it is not equal to the hold-all domain: ', Hold_All.Name]);
    disp(['ERROR: AND it is not a *subset* of the hold-all domain.']);
    error('ERROR: check your Domain definitions!');
end

end