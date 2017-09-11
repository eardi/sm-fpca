function [Curve_Vtx_NEW, END_OPT] = Image_Proc_Demo_LineSearch(P1_Mesh_DoFmap, Curve_Vtx, Image_Data,...
                                                               V_vec, PARAM)
%Image_Proc_Demo_LineSearch
%
%   Demo for FELICITY - 2-D image processing with active contours.

% Copyright (c) 09-26-2011,  Shawn W. Walker

% line search to obtain new curve
Curve_Vtx_NEW = []; % init
Current_J = Image_Proc_Demo_Compute_Cost(P1_Mesh_DoFmap, Curve_Vtx, Image_Data, PARAM); % do not change

% PARAM.init_step_size: this is the INITIAL step size to try
% Curve_Vtx: the current iteration of the curve \Gamma
% Curve_Vtx_NEW: the updated curve \Gamma
% step_size: the current step size to try
% V_vec: the search direction (or velocity), same size as "Curve_Vtx"
% END_OPT: boolean that indicates that the minimum step size has been reached

% NOTE:
% New_J = Image_Proc_Demo_Compute_Cost(P1_Mesh_DoFmap, Curve_Vtx_NEW, Image_Data, PARAM);

% error('YOU MUST FILL IN!');

% INSERT your line-search code here.  do not change the input or output
% arguments of this file.


alpha = 2 * PARAM.init_step_size; % init step size
% compute bogus cost in order to enter while loop
New_J = Current_J + 1;

END_OPT = false;
while (New_J - Current_J > 0) % backtrack
    alpha = alpha / 2; % reduce step size
    Curve_Vtx_NEW = Curve_Vtx + alpha * V_vec; % update curve position
    % evaluate new cost
    New_J = Image_Proc_Demo_Compute_Cost(P1_Mesh_DoFmap, Curve_Vtx_NEW, Image_Data, PARAM);
    if alpha < 1e-13
        disp('step size is too small... exiting line search loop.');
        END_OPT = true;
        break;
    end
end
disp(['step size is: ', num2str(alpha,'%1.5E')]);

end