function DS_Map = Filter_Domains(DS)
%Filter_Domains
%
%   This make a container.MAP variable to hold a unique list of domains.

% Copyright (c) 08-01-2011,  Shawn W. Walker

Num_DS = length(DS);

DS_Map = containers.Map();
for ind = 1:Num_DS
    DS_Map = append_Domain(DS_Map,DS(ind));
end

end

function MAP = append_Domain(MAP,DS)

if ismember(DS.Name,MAP.keys)
    % if that domain's name has already been used, then make sure the
    % struct (mostly) matches what was used before!
    Other_DS = MAP(DS.Name);
    if ~strcmp(DS.Type,Other_DS.Type)
        % if it doesn't match, then the user was doing things he shouldn't!
        disp(['ERROR: This Domain was redefined: ', DS.Name]);
        error('You should not redefine a Domain!');
    end
end
MAP(DS.Name) = DS;

end