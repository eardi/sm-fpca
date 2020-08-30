function SS = Get_Unique_List_Of_Domains(obj)
%Get_Unique_List_Of_Domains
%
%   This outputs a structure that looks like:
%   SS.Hold_All = Global container domain.
%   SS.Domain_Of_Integration(k).
%                     Domain = integration domain (that is embedded in Hold_All
%                              domain).
%                     Embeddings(j) = array of other domains that contain the
%                                     integration domain.  These embeddings will
%                                     need to be computed elsewhere (when the
%                                     mesh data is known).

% Copyright (c) 05-25-2012,  Shawn W. Walker

% this is THE GLOBAL container set; there should only be one of these no matter
% how many subdomains or domains of integration there are!
SS.Hold_All = obj.MATS.GeoElem.Domain;

% find all domains of integration first
Domains_Of_Integration = containers.Map();
for mi=1:length(obj.MATS.Matrix_Data)
    ID = obj.MATS.Matrix_Data{mi}.Integral;
    for kk=1:length(ID)
        DoI = ID(kk).Domain;
        if ismember(DoI.Name,Domains_Of_Integration.keys)
            % if that domain was used before, then make sure it did not change!
            if ~isequal(DoI,Domains_Of_Integration(DoI.Name))
                % if it doesn't match, then the user was doing things he shouldn't!
                disp(['ERROR: This Domain was redefined: ', DoI.Name]);
                error('You should not redefine a Domain!');
            end
        else
            Domains_Of_Integration(DoI.Name) = DoI;
        end
    end
end
% % limit to just one domain of integration (for now)
% if length(Domains_Of_Integration) > 1
%     error('Can only have one domain of integration.');
% end

List_Of_DoI_Names = Domains_Of_Integration.keys;
% store the Domain of Integration
SS.Domain_Of_Integration = create_domain_of_integration_struct(obj,Domains_Of_Integration(List_Of_DoI_Names{1}));
for ind = 2:length(List_Of_DoI_Names)
    % store the Domain of Integration
    SS.Domain_Of_Integration(ind) = create_domain_of_integration_struct(obj,Domains_Of_Integration(List_Of_DoI_Names{ind}));
end

% SS
% SS.Domain_Of_Integration(1)
% SS.Domain_Of_Integration(2)
% disp('==========================');
% SS.Domain_Of_Integration(1).Domain
% SS.Domain_Of_Integration(2).Domain
% disp('==========================');
% SS.Domain_Of_Integration(1).Embeddings
% SS.Domain_Of_Integration(2).Embeddings
% safdsafd

end

function DOI = create_domain_of_integration_struct(obj,Single_Domain_Of_Integration)
% this returns a struct:
%      DOI.Domain
%      DOI.Embeddings(k)
% the DOI.Embeddings(k) is a level 1 Domain that contains the DoI.
%
% So, for every basis function and coefficient function, we need to know that
% the Domain of Integration (DoI) is contained in the domain of definition of
% the function (i.e. we need to know to evaluate the function on a subset (DoI)
% of its domain of definition).  This routine records that in the Embeddings
% struct/field.  In other words, the Embeddings array contains all domains of
% definition that contain the DoI.

% store the Domain of integration
DOI.Domain = Single_Domain_Of_Integration;

Embed = containers.Map(); % init
for mi=1:length(obj.MATS.Matrix_Data)
    ID = obj.MATS.Matrix_Data{mi}.Integral;
    for di=1:length(ID)
        if isequal(ID(di).Domain,Single_Domain_Of_Integration)
            Embed = get_function_domain(Embed, ID(di).TestF, DOI.Domain);
            Embed = get_function_domain(Embed, ID(di).TrialF,DOI.Domain);
            Embed = get_function_domain(Embed, ID(di).CoefF, DOI.Domain);
        end
    end
%     obj.MATS.Matrix_Data{mi}.TestF
%     obj.MATS.Matrix_Data{mi}.TrialF
%     obj.MATS.Matrix_Data{mi}.CoefF
%     
%     Embed = get_function_domain(Embed, obj.MATS.Matrix_Data{mi}.TestF, DOI.Domain);
%     Embed = get_function_domain(Embed, obj.MATS.Matrix_Data{mi}.TrialF,DOI.Domain);
%     Embed = get_function_domain(Embed, obj.MATS.Matrix_Data{mi}.CoefF, DOI.Domain);
%     
%     for kk=1:length(ID)
%         % find all domains of integration that match...
%         if strcmp(ID(kk).Domain.Name,DOI.Domain.Name)
%             % ...and store the required embeddings
%             for ee=1:length(ID(kk).Embeddings)
%                 Embed(ID(kk).Embeddings(ee).Name) = ID(kk).Embeddings(ee);
%             end
%         end
%     end
end

% put into the struct
if ~isempty(Embed)
    keys = Embed.keys;
    DOI.Embeddings = Embed(keys{1});
    for kk = 2:length(keys)
        DOI.Embeddings(kk) = Embed(keys{kk});
    end
else
    DOI.Embeddings = []; % no additional embeddings are needed
end

end

function Embed = get_function_domain(Embed, FUNC, DOI_Domain)

for ind = 1:length(FUNC)
    % only need to add this functions domain of defn if it is different than the DoI
    if ~isequal(FUNC(ind).Element.Domain,DOI_Domain)
        % error check: make sure we are only dealing with functions that are
        % being *evaluated* on the DOI_Domain
        if ~isequal(FUNC(ind).Domain,DOI_Domain)
            error('Function (in integrand) must be evaluated on the domain of integration!');
        end
        % store the domain of defn of the function
        Embed(FUNC(ind).Element.Domain.Name) = FUNC(ind).Element.Domain;
    end
end

end