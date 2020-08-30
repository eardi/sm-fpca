function SS = Get_Unique_List_Of_Domains(obj)
%Get_Unique_List_Of_Domains
%
%   This outputs a structure that looks like:
%   SS.Hold_All = Global container domain.
%   SS.Domain_Of_Expression(k).
%                     Domain = expression domain (that is embedded in Hold_All
%                              domain).

% Copyright (c) 06-13-2014,  Shawn W. Walker

% this is THE GLOBAL container set; there should only be one of these no matter
% how many subdomains or domains of expression there are!
SS.Hold_All = obj.PTSEARCH.GeoElem.Domain;

% find all domains to search first
Domains_To_Search = containers.Map();
for ie=1:length(obj.PTSEARCH.Search_Domain)
    Current_Domain = obj.PTSEARCH.Search_Domain(ie);
    
    if ismember(Current_Domain.Name,Domains_To_Search.keys)
        % if that domain was used before, then make sure it did not change!
        if ~isequal(Current_Domain,Domains_To_Search(Current_Domain.Name))
            % if it doesn't match, then the user was doing things he shouldn't!
            disp(['ERROR: This Domain was redefined: ', Current_Domain.Name]);
            error('You should not redefine a Domain!');
        end
    else
        Domains_To_Search(Current_Domain.Name) = Current_Domain;
    end
end

List_Of_Dom_Names = Domains_To_Search.keys;
% store the Domain of Expression
SS.Domain_Of_Expression.Domain = Domains_To_Search(List_Of_Dom_Names{1});
for ind = 2:length(List_Of_Dom_Names)
    % store the Domain of Expression
    SS.Domain_Of_Expression.Domain = Domains_To_Search(List_Of_Dom_Names{ind});
end

% SS
% SS.Domain_Of_Expression(1)
% %SS.Domain_Of_Expression(2)
% disp('==========================');
% SS.Domain_Of_Expression(1).Domain
% %SS.Domain_Of_Expression(2).Domain
% disp('==========================');
% %SS.Domain_Of_Expression(1).Embeddings
% %SS.Domain_Of_Expression(2).Embeddings
% safdsafd

end