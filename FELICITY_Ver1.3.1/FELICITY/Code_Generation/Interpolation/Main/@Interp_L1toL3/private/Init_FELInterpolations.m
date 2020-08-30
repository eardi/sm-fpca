function [FS, FI] = Init_FELInterpolations(obj,FS,Snippet_Dir)
%Init_FELInterpolations
%
%   This inits and sets up the FELInterp object, i.e. this completes the
%   definition of the FEM interpolations.

% Copyright (c) 01-28-2013,  Shawn W. Walker

% FS.Space.values
% FS.Integration.BasisFunc('Vector_P1')
% FS.Integration.CoefFunc('v')

% init
FI = FELInterpolations(Snippet_Dir);
Num_Interp = length(obj.INTERP.Interp_Expr);
for ind = 1:Num_Interp
    IE = obj.INTERP.Interp_Expr{ind};
    FI = FI.Append_Interpolation(IE);
end

FI_Names = FI.keys;
Num_Interp = length(FI_Names);
for ind = 1:Num_Interp
    
    Interp_1 = FI.Interp(FI_Names{ind});
    
    % setup the interpolation (all components)
    for ri = 1:Interp_1.NumRow_SubINT
        for ci = 1:Interp_1.NumCol_SubINT
            [Interp_1, FS] = Interp_1.Set_Interpolation(FS,ri,ci);
        end
    end
    
    % copy over
    FI.Interp(FI_Names{ind}) = Interp_1;
end

end