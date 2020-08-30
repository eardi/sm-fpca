function CONST_TF = Is_Quantity_Constant(obj,FIELD_str)
%Is_Quantity_Constant
%
%   This outputs a boolean indicating if the given variable name is a CONSTANT
%   on a single element.

% Copyright (c) 01-11-2018,  Shawn W. Walker

CONST_TF = true; % yes, it is always constant

% if strcmp(FIELD_str,'Val')
%     CONST_TF = false; % never constant
% elseif strcmp(FIELD_str,'Grad')
%     CONST_TF = obj.Lin_PHI_TF; % if the map is linear, then this variable is constant
% elseif strcmp(FIELD_str,'Metric')
%     CONST_TF = obj.Lin_PHI_TF;
% elseif strcmp(FIELD_str,'Det_Metric')
%     CONST_TF = obj.Lin_PHI_TF;
% elseif strcmp(FIELD_str,'Inv_Det_Metric')
%     CONST_TF = obj.Lin_PHI_TF;
% elseif strcmp(FIELD_str,'Inv_Metric')
%     CONST_TF = obj.Lin_PHI_TF;
% elseif strcmp(FIELD_str,'Det_Jacobian')
%     CONST_TF = obj.Lin_PHI_TF;
% else
%     error('Not valid!');
% end

end