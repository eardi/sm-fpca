function obj = hess_inverse_map(obj)
%hess_inverse_map
%
%   Get (Hessian of PHI^{-1}) o PHI.  The indexing of this matrix is:
%   (i,j,k), where k is the kth component of the map.
%                  (i,j) is \partial_i \partial_j mixed 2nd order derivative.

% Copyright (c) 05-19-2016,  Shawn W. Walker

% represent hessian of inverse map symbolically
if (obj.GeoDim==1)
    % each component is a 1x1 matrix
    obj.PHI.Hess_Inv_Map = sym('PHI_Hess_Inv_Map_1_11');
elseif (obj.GeoDim==2)
    if (obj.TopDim==1)
        obj.PHI.Hess_Inv_Map = []; % not valid in this case!
    elseif (obj.TopDim==2)
        % each component is a 2x2 matrix
        obj.PHI.Hess_Inv_Map(2,2,2) = sym('0'); % init
%         obj.PHI.Hess_Inv_Map(:,:,1) = sym('[PHI_Hess_Inv_Map_1_11, PHI_Hess_Inv_Map_1_12; PHI_Hess_Inv_Map_1_21, PHI_Hess_Inv_Map_1_22]');
%         obj.PHI.Hess_Inv_Map(:,:,2) = sym('[PHI_Hess_Inv_Map_2_11, PHI_Hess_Inv_Map_2_12; PHI_Hess_Inv_Map_2_21, PHI_Hess_Inv_Map_2_22]');
        obj.PHI.Hess_Inv_Map(:,:,1) = sym('PHI_Hess_Inv_Map_1_%d%d',[2 2]);
        obj.PHI.Hess_Inv_Map(:,:,2) = sym('PHI_Hess_Inv_Map_2_%d%d',[2 2]);
    end
elseif (obj.GeoDim==3)
    if (obj.TopDim==1)
        obj.PHI.Hess_Inv_Map = []; % not valid in this case!
    elseif (obj.TopDim==2)
        obj.PHI.Hess_Inv_Map = []; % not valid in this case!
    elseif (obj.TopDim==3)
        % each component is a 3x3 matrix
        obj.PHI.Hess_Inv_Map(3,3,3) = sym('0'); % init
        obj.PHI.Hess_Inv_Map(:,:,1) = sym('PHI_Hess_Inv_Map_1_%d%d',[3 3]);
        obj.PHI.Hess_Inv_Map(:,:,2) = sym('PHI_Hess_Inv_Map_2_%d%d',[3 3]);
        obj.PHI.Hess_Inv_Map(:,:,3) = sym('PHI_Hess_Inv_Map_3_%d%d',[3 3]);
    end
end

end