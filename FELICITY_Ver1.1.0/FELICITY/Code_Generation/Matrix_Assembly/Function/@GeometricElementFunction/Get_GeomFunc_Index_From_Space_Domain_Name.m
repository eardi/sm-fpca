function GF_Index = Get_GeomFunc_Index_From_Space_Domain_Name(obj,Integration_Set_Name,Space_Domain_Name)
%Get_GeomFunc_Index_From_Space_Domain_Name
%
%   For each Space index, this returns the corresponding GeomFunc index for the
%   given Integration_Set_Name.  note: GF_Index indexes into obj(:).

% Copyright (c) 04-10-2010,  Shawn W. Walker

Num_GeomFunc = length(obj);
GF_Index = 0;

if strcmp(Space_Domain_Name,Integration_Set_Name)
    % Space is defined ON the domain of integration
    for gi = 1:Num_GeomFunc
        if or(strcmp(obj(gi).Map_Type,'intrinsic'),strcmp(obj(gi).Map_Type,''))
            % the map is intrinsic
            if strcmp(obj(gi).Domain.Integration_Set.Name,Space_Domain_Name)
                % map's domain and Space's domain match
                GF_Index = gi;
                break;
            end
        end
    end
else
    % Space is defined on a domain that CONTAINS the domain of integration
    for gi = 1:Num_GeomFunc
        if strcmp(obj(gi).Map_Type,'trace')
            % the map is a trace from Hold_All domain  TO  Integration_Set
            if and(strcmp(obj(gi).Domain.Hold_All.Name,Space_Domain_Name),...
                    strcmp(obj(gi).Domain.Integration_Set.Name,Integration_Set_Name))
                % then the Space domain matches the Map's Hold_All domain AND
                %      the Integration domain matches the Map's Integration_Set
                GF_Index = gi;
                break;
            end
        end
    end
end

end