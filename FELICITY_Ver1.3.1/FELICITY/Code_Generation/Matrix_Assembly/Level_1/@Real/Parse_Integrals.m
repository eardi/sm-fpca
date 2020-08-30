function [Parsed, Num_Nonzeros] = Parse_Integrals(obj)
%Parse_Integrals
%
%   This parses the integrals (in a Real matrix) into a more useable struct.
%
%   [Parsed, Num_Nonzeros] = obj.Parse_Integrals;
%
%   Parsed = array (length M) of structs:
%            .Integrand_Sym(:,:) = RxC sym expression (R,C is the row and col
%                                  dimensions of 'obj').
%            .Domain = RxC cell array of Level 1 Domains (corresponding to
%                      Integrand_Sym).
%            .TestF  = [].
%            .TrialF = [].
%            Note: Parsed(k) corresponds to the unique kth Domain of Integration.
%   Num_Nonzeros = column vector (length M) where Num_Nonzeros(i) is the number
%                  of non-zero terms in the matrix:  Parsed(i).Integrand_Sym.

% Copyright (c) 06-22-2012,  Shawn W. Walker

% example:
%
% suppose this object (obj) is 2x2, with integrals for each entry looking like:
%
% ----------------------------------------------------------------------
% | \int_\Omega ... +  \int_\Gamma  | \int_\Omega                      |
% ----------------------------------------------------------------------
% | \int_\Gamma                     |     0                            |
% ----------------------------------------------------------------------
%
% this routine creates an array of structs that mimics this:
%
% Parsed(1).Integrand_Sym(:,:) are integrands evaluated on \int_\Omega:
% ----------------------------------------------------------------------
% | \int_\Omega                     | \int_\Omega                      |
% ----------------------------------------------------------------------
% |      0                          |     0                            |
% ----------------------------------------------------------------------
%
% Parsed(2).Integrand_Sym(:,:) are integrands evaluated on \int_\Gamma:
% ----------------------------------------------------------------------
% | \int_\Gamma                     |     0                            |
% ----------------------------------------------------------------------
% | \int_\Gamma                     |     0                            |
% ----------------------------------------------------------------------

% get unique list of integration domains
Domains = containers.Map;
for ind = 1:length(obj(:))
    if ~isempty(obj(ind).Integral)
        Domains(obj(ind).Integral.Domain.Name) = obj(ind).Integral.Domain;
    end
end
DoI_Names = Domains.keys;

% manually init Parsed structure
Parsed = get_parsed_struct;
for di = 1:length(DoI_Names)
    Parsed(di).Integrand_Sym = sym(zeros(size(obj))); % all zero sym matrix
    Parsed(di).Domain        = cell(size(obj));
    for ir = 1:size(obj,1)
        for ic = 1:size(obj,2)
            % fill with the *same* domain
            Parsed(di).Domain{ir,ic} = Domains(DoI_Names{di});
        end
    end
end

% now fill the integrand
Num_Nonzeros = zeros(length(Parsed),1);
for ri = 1:size(obj,1)
    for ci = 1:size(obj,2)
        % get the Integral object (array) for the (ri,ci) entry in the "Real" matrix
        ID = obj(ri,ci).Integral;
        % loop through all of the individual Integral(s)
        for ii = 1:length(ID)
            % loop through each unique Domain
            for pp = 1:length(Parsed)
                % if the Integral's Domain matches,
                if isequal(ID(ii).Domain,Parsed(pp).Domain{1,1})
                    % then store it in the Parsed structure according to that Domain
                    Parsed(pp).Integrand_Sym(ri,ci) = ID.Integrand;
                    Num_Nonzeros(pp) = Num_Nonzeros(pp) + 1;
                end
            end
        end
    end
end

end

function SS = get_parsed_struct()

SS.Integrand_Sym       = [];
SS.Domain              = [];
SS.TestF               = [];
SS.TrialF              = [];

end