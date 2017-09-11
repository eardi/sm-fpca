function [DoI_GeomFunc, DoI_GeomIndex] = Get_Intrinsic_GeomFunc(Intrinsic_Domain_Name,Spaces)
%Get_Intrinsic_GeomFunc
%
%   This will return a *single* GeomFunc corresponding to the intrinsic map for
%   the given domain.

% Copyright (c) 03-14-2012,  Shawn W. Walker

error('SWW: this is not used!');

% find the intrinsic GeomFunc
% (i.e. the function that describes the domain of integration).
DoI_GeomIndex = Spaces.Get_GeomFunc_Index(Intrinsic_Domain_Name,'intrinsic');

% extract *single* geometric function
DoI_GeomFunc = Spaces.DoI_Geom(DoI_GeomIndex);

% remove options that have been set
% we want to start with a blank slate
DoI_GeomFunc = DoI_GeomFunc.Reset_Options;

% set this option (we always need this geometric quantity!)
DoI_GeomFunc.Opt.Det_Jacobian_with_quad_weight = true;

end