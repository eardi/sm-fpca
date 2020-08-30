function obj = grad_map(obj)
%grad_map
%
%   Get the gradient of PHI.

% Copyright (c) 05-19-2016,  Shawn W. Walker

% represent gradient symbolically
obj.PHI.Grad = sym('PHI_Grad_%d%d',[obj.GeoDim obj.TopDim]);

% % represent gradient symbolically
% if (obj.GeoDim==1)
%     obj.PHI.Grad = sym('PHI_Grad_11');
% elseif (obj.GeoDim==2)
%     if (obj.TopDim==1)
%         %obj.PHI.Grad = sym('[PHI_Grad_11; PHI_Grad_21]');
%         obj.PHI.Grad = sym('PHI_Grad_%d%d',[2 1]);
%     elseif (obj.TopDim==2)
%         %obj.PHI.Grad = sym('[PHI_Grad_11, PHI_Grad_12; PHI_Grad_21, PHI_Grad_22]');
%         obj.PHI.Grad = sym('PHI_Grad_%d%d',[2 2]);
%     end
% elseif (obj.GeoDim==3)
%     if (obj.TopDim==1)
%         %obj.PHI.Grad = sym('[PHI_Grad_11; PHI_Grad_21; PHI_Grad_31]');
%         obj.PHI.Grad = sym('PHI_Grad_%d%d',[3 1]);
%     elseif (obj.TopDim==2)
%         %obj.PHI.Grad = sym('[PHI_Grad_11, PHI_Grad_12; PHI_Grad_21, PHI_Grad_22; PHI_Grad_31, PHI_Grad_32]');
%         obj.PHI.Grad = sym('PHI_Grad_%d%d',[3 2]);
%     elseif (obj.TopDim==3)
%         %obj.PHI.Grad = sym('[PHI_Grad_11, PHI_Grad_12, PHI_Grad_13; PHI_Grad_21, PHI_Grad_22, PHI_Grad_23; PHI_Grad_31, PHI_Grad_32, PHI_Grad_33]');
%         obj.PHI.Grad = sym('PHI_Grad_%d%d',[3 3]);
%     end
% end

end