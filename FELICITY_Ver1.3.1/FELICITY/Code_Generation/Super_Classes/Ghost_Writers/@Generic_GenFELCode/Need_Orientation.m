function TF = Need_Orientation(obj,FS)
%Need_Orientation
%
%   This indicates if mesh orientation data is needed.

% Copyright (c) 06-25-2012,  Shawn W. Walker

TF = false;

for ind = 1:length(FS.Integration)
    Opt = FS.Integration(ind).DoI_Geom.Opt;
    TF = orientation_present(Opt);
    
    if ~TF
        BF_Set = FS.Integration(ind).BasisFunc.values;
        for bi = 1:length(BF_Set)
            Opt = BF_Set{bi}.GeomFunc.Opt;
            TF = orientation_present(Opt);
        end
    end
    
    if TF
        break;
    end
end

end

function TF = orientation_present(Opt)

TF = false;

if isfield(Opt,'Orientation')
    if Opt.Orientation
        TF = true;
    end
end

end