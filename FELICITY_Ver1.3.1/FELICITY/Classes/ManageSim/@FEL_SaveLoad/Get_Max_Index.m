function Max_Ind = Get_Max_Index(obj)
%Get_Max_Index
%
%   Get the largest file index in the stored data directory.
%
%   Max_Ind = obj.Get_Max_Index;
%
%   Valid values:  0, 1, 2,...
%   Invalid values:  -1  (meaning no matching files found).

% Copyright (c) 04-09-2014,  Shawn W. Walker

% get all the file data
DD = dir(obj.Main_Dir);
Num_DD = length(DD);

% get prefixes
Prefix = obj.File_Prefix;

% init
Max_Ind = -1; % invalid value

% now loop through it and count which files match the prefix
for ind = 1:Num_DD
    
    if ~DD(ind).isdir % only count if it is NOT a directory
        FN = DD(ind).name;
        
        % match cnt file
        Match_EXPR = [Prefix, '(\d+)', '.mat'];
        m = regexp(FN, Match_EXPR, 'match');
        if ~isempty(m)
            tokens = regexp(FN, Match_EXPR, 'tokens');
            CI = str2double(tokens{1});
            % keep track of the largest
            Max_Ind = max(Max_Ind,CI);
        end
    end
    
end

end