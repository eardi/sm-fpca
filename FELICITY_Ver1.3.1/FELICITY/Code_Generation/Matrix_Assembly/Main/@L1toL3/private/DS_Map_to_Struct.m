function DS = DS_Map_to_Struct(DS_Map)
%DS_Map_to_Struct
%
%   This converts a container.MAP variable to an array of structs.

% Copyright (c) 08-01-2011,  Shawn W. Walker

DS_Name_cell = DS_Map.keys;
Num_Domains = length(DS_Name_cell);

DS = DS_Map(DS_Name_cell{1}); % init
for ind = 2:Num_Domains
    DS(ind) = DS_Map(DS_Name_cell{ind});
end

end