function status = Run_Image_Processing_Demo()
%Run_Image_Processing_Demo
%
%   Demo for FELICITY - 2-D image processing with active contours.

% Copyright (c) 09-26-2011,  Shawn W. Walker

Num_Opt_Iter = 100; % number of optimization iterations

% user parameters
PARAM.init_step_size = 0.4; % 0.4 initial step size to try
PARAM.mu     = 0.003; % 0.003 curve length penalty
PARAM.Cin    = 0.0; % 0.0,  inside pixel value (dark)
PARAM.Cout   = 1.0; % 1.0,  outside pixel value (light)
PARAM.W_L2   = 1.0; % 1.0,  L^2 weight
PARAM.W_H1   = PARAM.W_L2/20; % 1/20, H^1 weight

% init mesh
[P1_Mesh_DoFmap, P1_Mesh_Vtx, Image_Data] = Image_Proc_Demo_Init();

% optimization loop
Curve.Vtx = P1_Mesh_Vtx; % init
Curve.Vel = 0*P1_Mesh_Vtx; % init
for ind=1:Num_Opt_Iter
    [New_Vtx, V_vec, END_OPT, PARAM] = Image_Proc_Demo_Optimization_Step(P1_Mesh_DoFmap, Curve(ind).Vtx, Image_Data, PARAM);
    Curve(ind+1).Vtx = New_Vtx;
    Curve(ind+1).Vel = V_vec;
    disp(['Optimization Iteration #', num2str(ind), ' finished.']);
    if END_OPT
        disp('Since the last step size was small, we stop the optimization.');
        break;
    end
    if (ind==-1)
        PARAM.mu = 0.5e-3;
    end
end

%PARAM

INDEX = length(Curve);
figure;
imagesc(Image_Data.X,Image_Data.Y,Image_Data.I);
colormap(gray);
axis image;
hold on;
X = [Curve(INDEX).Vtx(:,1); Curve(INDEX).Vtx(1,1)];
Y = [Curve(INDEX).Vtx(:,2); Curve(INDEX).Vtx(1,2)];
plot(X,Y,'r-','LineWidth',2);
quiver(Curve(INDEX).Vtx(:,1),Curve(INDEX).Vtx(:,2),...
       Curve(INDEX).Vel(:,1),Curve(INDEX).Vel(:,2),'Color','b');
hold off;
title('Red curve is contour; Blue arrows are the last velocity update');

status = 0; % init

end