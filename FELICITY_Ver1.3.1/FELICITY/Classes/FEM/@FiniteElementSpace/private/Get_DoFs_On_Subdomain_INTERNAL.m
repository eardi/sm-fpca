function DoFs = Get_DoFs_On_Subdomain_INTERNAL(obj,Subdomain)
%Get_DoFs_On_Subdomain_INTERNAL
%
%   This returns a list of DoF node indices (of DoFmap) that are attached to the
%   given subdomain.
%
%   DoFs = obj.Get_DoFs_On_Subdomain_INTERNAL(Subdomain);
%
%   Subdomain = subdomain data that is already referenced to the obj.DoFmap.
%               I.e. Subdomain.Data(:,1) are cell indices that point to
%               the rows of obj.DoFmap.  This means some pre-processing has
%               happened to make the given Subdomain reference the *local*
%               mesh on which the DoFmap is defined.
%              (That's why this is an INTERNAL subroutine.)
%
%   DoFs = is an (increasing) ordered array (length R) of unique DoF indices in
%          obj.DoFmap that are attached to the given subdomain.
%          Note: this is only for the 1st component in a tuple-valued space.

% Copyright (c) 04-27-2012,  Shawn W. Walker

if (min(Subdomain.Data(:,1)) < 1)
    error('Subdomain.Data has invalid local enclosing cell index references!');
end
if (max(Subdomain.Data(:,1)) > size(obj.DoFmap,1))
    error('Subdomain.Data has local enclosing cell index references outside valid range!');
end

% get topological dimension of the subdomain on which the DoFmap is defined.
DoF_Top_Dim = obj.RefElem.Top_Dim;

% first get subset of DoF *cells* that contain the subdomain.
DoFmap_TEMP = obj.DoFmap(Subdomain.Data(:,1),:);

if (DoF_Top_Dim==Subdomain.Dim) % easy case
    DoFs = unique(DoFmap_TEMP(:));
else
    % need to get all possible sets of local DoFs for each local topological
    % entity
    Top_Entity = obj.RefElem.Get_Nodes_On_Topological_Entity(Subdomain.Dim);
    
    % then sweep through global DoF array and extract based on the local
    % topological entity
    
    % get mask for each topological entity
    % note: we don't care about the sign (orientation) of the entity
    M.Mask = (abs(Subdomain.Data(:,2)) == 1);
    for ind = 2:size(Top_Entity,1)
        M(ind).Mask = (abs(Subdomain.Data(:,2)) == ind);
    end
    
    % extract just those particular DoF indices
    DoFs = [];
    for ind = 1:size(Top_Entity,1)
        DFT = DoFmap_TEMP(M(ind).Mask,Top_Entity(ind,:));
        DoFs = [DoFs; unique(DFT(:))];
    end
    DoFs = unique(DoFs);
end

end