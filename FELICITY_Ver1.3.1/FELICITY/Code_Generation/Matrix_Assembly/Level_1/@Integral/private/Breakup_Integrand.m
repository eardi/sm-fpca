function Parsed_Integrand = Breakup_Integrand(obj,TestF_Parsed,TrialF_Parsed)
%Breakup_Integrand
%
%   This breaks up the integrand into several additive pieces.
%
%   Parsed_Integrand = obj.Breakup_Integrand(TestF_Parsed,TrialF_Parsed);
%
%   TestF_Parsed  = (see the output of 'Parse_Vars_From_Given_Function').
%   TrialF_Parsed = (see the output of 'Parse_Vars_From_Given_Function').
%
%   Parsed_Integrand = RxC sym expression (R,C depend on whether the Test and
%                      Trial Spaces are tensor valued).

% Copyright (c) 08-01-2011,  Shawn W. Walker

% just insert a bogus value if they are empty...
% it won't affect the later code.
% of course, I am assuming that no one will use BOGUS as a variable name...
BOGUS = 'XXXXXXXXXYYYYYYYYYZZZZZZZZZZZ';
if isempty(TestF_Parsed)
    TestF_Parsed = {[sym(BOGUS)]};
end
if isempty(TrialF_Parsed)
    TrialF_Parsed = {[sym(BOGUS)]};
end
Num_TestF_Tuple  = length(TestF_Parsed);
Num_TrialF_Tuple = length(TrialF_Parsed);

% init
Parsed_Integrand = sym(zeros(Num_TestF_Tuple,Num_TrialF_Tuple));
test_indices     = (1:1:Num_TestF_Tuple)';
trial_indices    = (1:1:Num_TrialF_Tuple)';

for test_i = 1:Num_TestF_Tuple
    % get full integrand
    SYM_INTEGRAND = obj.Integrand;
    % TEST: set other tensor indices in integrand to zero
    zero_out_test_indices = setdiff(test_indices,test_i);
    zero_out_test_vars = TestF_Parsed(zero_out_test_indices);
    SYM_INTEGRAND_after_test = obj.Set_Terms_In_Expression_To_Zero(SYM_INTEGRAND,zero_out_test_vars);
    for trial_i = 1:Num_TrialF_Tuple
        % TRIAL: set other tensor indices in integrand to zero
        zero_out_trial_indices = setdiff(trial_indices,trial_i);
        zero_out_trial_vars = TrialF_Parsed(zero_out_trial_indices);
        SYM_INTEGRAND_final = obj.Set_Terms_In_Expression_To_Zero(SYM_INTEGRAND_after_test,zero_out_trial_vars);
        Parsed_Integrand(test_i,trial_i) = SYM_INTEGRAND_final;
    end
end

end