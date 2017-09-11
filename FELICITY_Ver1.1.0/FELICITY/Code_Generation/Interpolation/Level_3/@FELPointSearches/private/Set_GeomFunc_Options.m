function GF = Set_GeomFunc_Options(GF)
%Set_GeomFunc_Options
%
%   This returns GF with appropriate options set depending on the topological and
%   geometric dimension of GF.Domain.Subdomain.

% Copyright (c) 06-27-2014,  Shawn W. Walker

% we always need this
GF.Opt.Val = true;

Subdomain = GF.Domain.Subdomain;
GeoDim    = Subdomain.GeoDim;
TopDim    = Subdomain.Top_Dim();

if (GeoDim==1)
    GF.Opt.Inv_Grad = true;
elseif (GeoDim==2)
    if (TopDim==1)
        GF.Opt.Grad = true;
    elseif (TopDim==2)
        GF.Opt.Inv_Grad = true;
    else
        error('Invalid!');
    end
elseif (GeoDim==3)
    if (TopDim==1)
        GF.Opt.Grad = true;
    elseif (TopDim==2)
        GF.Opt.Grad = true;
    elseif (TopDim==3)
        GF.Opt.Inv_Grad = true;
    else
        error('Invalid!');
    end
else
    error('Invalid!');
end

end