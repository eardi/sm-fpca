function obj = second_fund_form(obj)
%second_fund_form
%
%   Get the 2nd fundamental form of PHI.

% Copyright (c) 05-19-2016,  Shawn W. Walker

% represent 2nd fundamental form symbolically
if (obj.GeoDim==1)
    if (obj.TopDim==1)
        obj.PHI.Second_Fund_Form = []; % this concept is not useful here; just use the hessian!
    else
        error('Not valid!');
    end
elseif (obj.GeoDim==2)
    if (obj.TopDim==1)
        obj.PHI.Second_Fund_Form = sym('PHI_2nd_Fund_Form_11');
    elseif (obj.TopDim==2)
        obj.PHI.Second_Fund_Form = []; % this concept is not useful here; just use the hessian!
    else
        error('Not valid!');
    end
elseif (obj.GeoDim==3)
    if (obj.TopDim==1)
        % the second fundamental form is inconvenient here:
        %     you need a basis of the orthogonal complement of the tangent space
        %     which is not unique because it is a 2-D space.  So, we will not
        %     use it.
        obj.PHI.Second_Fund_Form = [];
    elseif (obj.TopDim==2)
        obj.PHI.Second_Fund_Form = sym('PHI_2nd_Fund_Form_%d%d',[2 2]);
    elseif (obj.TopDim==3)
        obj.PHI.Second_Fund_Form = []; % this concept is not useful here; just use the hessian!
    else
        error('Not valid!');
    end
end

end