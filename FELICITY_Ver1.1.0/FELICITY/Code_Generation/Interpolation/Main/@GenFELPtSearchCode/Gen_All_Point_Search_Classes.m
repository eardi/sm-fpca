function Gen_All_Point_Search_Classes(obj,FPS)
%Gen_All_Point_Search_Classes
%
%   This generates a class file for each domain to be point searched.

% Copyright (c) 06-26-2014,  Shawn W. Walker

% generate code for each domain to be searched
Search_Domains = FPS.Get_Distinct_Domains;
NUM_Domains = length(Search_Domains);
for di = 1:NUM_Domains
    obj.Gen_Point_Search_Specific_cc(FPS,Search_Domains{di});
end

end