function [Parsed, NNZ] = Parse_Integrand_With_Functions(obj)
%Parse_Integrand_With_Functions
%
%   This parses the integrand into several (additive) pieces.  Used for
%   determining the number of sub-matrices in the case of tensor defined finite
%   elements.
%
%   [Parsed, NNZ] = obj.Parse_Integrand_With_Functions;
%
%   Parsed = struct:
%            .Integrand_Sym(:,:) = RxC sym expression (R,C depend on whether the
%                                  Test and Trial Spaces are tensor valued).
%            .Domain = Level 1 Domain of Integral.
%            .TestF  = Level 1 Test  object (i.e. the Test  Space).
%            .TrialF = Level 1 Trial object (i.e. the Trial Space).
%   NNZ    = number of non-zero terms in the matrix:  Parsed.Integrand_Sym.

% Copyright (c) 08-01-2011,  Shawn W. Walker

% parse out the test and trial function terms by tensor components
[TestF_Parsed, TrialF_Parsed] = obj.Get_Function_Parts_In_Integrand;

% break-up the integrand
Parsed.Integrand_Sym = obj.Breakup_Integrand(TestF_Parsed,TrialF_Parsed);
Parsed.Domain        = cell(size(Parsed.Integrand_Sym)); % init

% record the test and trial functions, which will be accessed later
Parsed.TestF  = obj.TestF;
Parsed.TrialF = obj.TrialF;

% get number of NON-zero terms
NNZ = 0;
ZERO = sym(0);
for i1 = 1:size(Parsed.Integrand_Sym,1)
    for j1 = 1:size(Parsed.Integrand_Sym,2)
        SYM_str = Parsed.Integrand_Sym(i1,j1);
        Parsed.Domain{i1,j1} = obj.Domain; % fill to have struct match what the `Real' case gives
        % so, yes, this is redundant to match with the `Real' Level 1 object
        if ~(SYM_str==ZERO)
            NNZ = NNZ + 1;
        end
    end
end

if NNZ == 0
    disp('The number of non-zero terms should be positive.');
    error('Check your integrand definition!');
end

end