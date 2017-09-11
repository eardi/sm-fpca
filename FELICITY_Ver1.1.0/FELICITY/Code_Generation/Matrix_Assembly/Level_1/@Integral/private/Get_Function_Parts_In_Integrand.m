function [TestF_Parsed, TrialF_Parsed] = Get_Function_Parts_In_Integrand(obj)
%Get_Function_Parts_In_Integrand
%
%   This parses out the test and trial functions.
%
%   [TestF_Parsed, TrialF_Parsed] = obj.Get_Function_Parts_In_Integrand;
%
%   TestF_Parsed  = (see the output of 'Parse_Vars_From_Given_Function').
%   TrialF_Parsed = (see the output of 'Parse_Vars_From_Given_Function').

% Copyright (c) 08-01-2011,  Shawn W. Walker

VARS = symvar(obj.Integrand);

% parse out the test function
TestF_Parsed = [];
if ~isempty(obj.TestF)
    TestF_Parsed = obj.Parse_Vars_From_Given_Function(obj.TestF,VARS);
end

% parse out the trial function
TrialF_Parsed = [];
if ~isempty(obj.TrialF)
    TrialF_Parsed = obj.Parse_Vars_From_Given_Function(obj.TrialF,VARS);
end

end