function [obj, SUCCESS] = Try_To_Combine_Integrals(obj,Int_Obj)
%Try_To_Combine_Integrals
%
%   This attempts to combine the given integral with an integral that was
%   defined before.  If it succeeds, it returns true, else false.
%
%   [obj, SUCCESS] = obj.Try_To_Combine_Integrals(Int_Obj);
%
%   Int_Obj = a Level 1 Integral object.
%
%   SUCCESS = (see above).

% Copyright (c) 06-22-2012,  Shawn W. Walker

% if the new integral is defined over a domain that was used in another
% integral, then we can just combine those integrals

SUCCESS = false; % init

Num_Int = length(obj.Integral);
for ind = 1:Num_Int
    
    NEW = Int_Obj + obj.Integral(ind); % use ``Integral'' + operator
    
    % check if we succeeded
    if isequal(NEW.Integrand,(Int_Obj.Integrand + obj.Integral(ind).Integrand))
        SUCCESS = true; % init
        obj.Integral(ind) = NEW; % store it!
        break;
    end
end

end