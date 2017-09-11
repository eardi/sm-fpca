function status = Verify_Distinct_Function_Names(obj)
%Verify_Distinct_Function_Names
%
%   This verifies that the Test, Trial, Coef, and GeoFunc functions all have distinct
%   external workspace names.
%
%   status = obj.Verify_Distinct_Function_Names;
%
%   status = 0, if routine successfully completes.

% Copyright (c) 01-23-2014,  Shawn W. Walker

NAMES{1} = [];
cnt = 0;
if ~isempty(obj.TestF)
    cnt = cnt + 1;
    NAMES{cnt} = obj.TestF.Name;
end
if ~isempty(obj.TrialF)
    cnt = cnt + 1;
    NAMES{cnt} = obj.TrialF.Name;
end

num_coef = length(obj.CoefF);
for ind=1:num_coef
    cnt = cnt + 1;
    NAMES{cnt} = obj.CoefF(ind).Name;
end

num_geof = length(obj.GeoF);
for ind=1:num_geof
    cnt = cnt + 1;
    NAMES{cnt} = obj.GeoF(ind).Name;
end

if (cnt==0)
    % no input arguments were given
    NAMES = [];
end

U_NAMES = unique(NAMES);
if length(U_NAMES) < cnt
    error('Not all function names are distinct!');
end

status = 0;

end