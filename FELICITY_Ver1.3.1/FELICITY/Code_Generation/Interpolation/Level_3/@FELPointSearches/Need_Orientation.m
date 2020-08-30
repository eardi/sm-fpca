function TF = Need_Orientation(obj)
%Need_Orientation
%
%   This indicates if mesh orientation data is needed.

% Copyright (c) 06-26-2014,  Shawn W. Walker

GeomFunc = obj.GeomFuncs.values;

% if an option has been set (in any geometric function) for orientation data,
%    then return true!
TF = false; % init
for ind = 1:length(GeomFunc)
    GF = GeomFunc{ind};
    
    Opt = GF.Opt;
    TF = orientation_present(Opt);
    
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