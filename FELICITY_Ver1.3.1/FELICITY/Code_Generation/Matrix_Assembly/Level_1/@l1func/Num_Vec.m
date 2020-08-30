function [NR, NC] = Num_Vec(obj)
%Num_Vec
%
%   This returns the number of vector components or matrix components.
%
%   [NR, NC] = obj.Num_Vec;

% Copyright (c) 03-22-2018,  Shawn W. Walker

% special case for H(div) or H(curl)
if or(strcmp(obj.Element.Elem.Transformation,'Hdiv_Trans'),strcmp(obj.Element.Elem.Transformation,'Hcurl_Trans'))
    % vector fields are in the tangent space of the domain, so the
    % dimension is whatever the ambient dimension is
    NR = obj.Element.Domain.GeoDim;
    NC = 1;
elseif strcmp(obj.Element.Elem.Transformation,'Hdivdiv_Trans')
    % matrix fields are in the tangent space of the domain, so the
    % dimension is whatever the ambient dimension is
    NR = obj.Element.Domain.GeoDim;
    NC = NR;
else
    [NR, NC] = size(obj.Element.Elem.Basis(1).Func);
    if (NC~=1)
        disp('What is this?');
        error('Basis functions can only be column vectors (will improve later).');
    end
end

end