function SS = Get_Unique_List_Of_Domains(obj)
%Get_Unique_List_Of_Domains
%
%   This outputs a structure that looks like:
%   SS.Hold_All = Global container domain.
%   SS.Domain_Of_Expression(k).
%                     Domain = expression domain (that is embedded in Hold_All
%                              domain).
%                     Embeddings(j) = array of other domains that contain the
%                                     expression domain.  These embeddings will
%                                     need to be computed elsewhere (when the
%                                     mesh data is known).

% Copyright (c) 01-28-2013,  Shawn W. Walker

% this is THE GLOBAL container set; there should only be one of these no matter
% how many subdomains or domains of expression there are!
SS.Hold_All = obj.INTERP.GeoElem.Domain;

% find all domains of expressions first
Domains_Of_Expression = containers.Map();
for ie=1:length(obj.INTERP.Interp_Expr)
    I_Expr = obj.INTERP.Interp_Expr{ie};
    
    Expr_Dom = I_Expr.Domain;
    if ismember(Expr_Dom.Name,Domains_Of_Expression.keys)
        % if that domain was used before, then make sure it did not change!
        if ~isequal(Expr_Dom,Domains_Of_Expression(Expr_Dom.Name))
            % if it doesn't match, then the user was doing things he shouldn't!
            disp(['ERROR: This Domain was redefined: ', Expr_Dom.Name]);
            error('You should not redefine a Domain!');
        end
    else
        Domains_Of_Expression(Expr_Dom.Name) = Expr_Dom;
    end
end

List_Of_Dom_Names = Domains_Of_Expression.keys;
% store the Domain of Expression
SS.Domain_Of_Expression = create_domain_of_expression_struct(obj,Domains_Of_Expression(List_Of_Dom_Names{1}));
for ind = 2:length(List_Of_Dom_Names)
    % store the Domain of Expression
    SS.Domain_Of_Expression(ind) = create_domain_of_expression_struct(obj,Domains_Of_Expression(List_Of_Dom_Names{ind}));
end

% SS
% SS.Domain_Of_Expression(1)
% %SS.Domain_Of_Expression(2)
% disp('==========================');
% SS.Domain_Of_Expression(1).Domain
% %SS.Domain_Of_Expression(2).Domain
% disp('==========================');
% SS.Domain_Of_Expression(1).Embeddings
% %SS.Domain_Of_Expression(2).Embeddings
% safdsafd

end

function DOE = create_domain_of_expression_struct(obj,Single_Domain_Of_Expression)
% this returns a struct:
%      DOE.Domain
%      DOE.Embeddings(k)
% the DOE.Embeddings(k) is a level 1 Domain that contains the DoE.
%
% So, for every coefficient function, we need to know that
% the Domain of Expression (DoE) is contained in the domain of definition of
% the function (i.e. we need to know to evaluate the function on a subset (DoE)
% of its domain of definition).  This routine records that in the Embeddings
% struct/field.  In other words, the Embeddings array contains all domains of
% definition (of the functions) that contain the DoE.

% store the Domain of Expression
DOE.Domain = Single_Domain_Of_Expression;

Embed = containers.Map(); % init
for ie=1:length(obj.INTERP.Interp_Expr)
    I_Expr = obj.INTERP.Interp_Expr{ie};
    
    if isequal(I_Expr.Domain,Single_Domain_Of_Expression)
        Embed = get_function_domain(Embed, I_Expr.CoefF, DOE.Domain);
    end
end

% put into the struct
if ~isempty(Embed)
    keys = Embed.keys;
    DOE.Embeddings = Embed(keys{1});
    for kk = 2:length(keys)
        DOE.Embeddings(kk) = Embed(keys{kk});
    end
else
    DOE.Embeddings = []; % no additional embeddings are needed
end

end

function Embed = get_function_domain(Embed, FUNC, DOE_Domain)

for ind = 1:length(FUNC)
    % only need to add this functions domain of defn if it is different than the
    % DoE
    if ~isequal(FUNC(ind).Element.Domain,DOE_Domain)
        % error check: make sure we are only dealing with functions that are
        % being *evaluated* on the DOE_Domain
        if ~isequal(FUNC(ind).Domain,DOE_Domain)
            error('Function (in expression) must be evaluated on the domain of expression!');
        end
        % store the domain of defn of the function
        Embed(FUNC(ind).Element.Domain.Name) = FUNC(ind).Element.Domain;
    end
end

end