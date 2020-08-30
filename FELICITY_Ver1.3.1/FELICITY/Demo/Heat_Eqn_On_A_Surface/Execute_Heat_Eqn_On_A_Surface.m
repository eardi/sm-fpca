function status = Execute_Heat_Eqn_On_A_Surface()
%Execute_Heat_Eqn_On_A_Surface
%
%   Demo code for solving the heat equation on a generic closed surface.

% Copyright (c) 02-02-2015,  Shawn W. Walker

% BEGIN: define sphere mesh
Refine_Level = 5; % 5
[TRI, VTX] = triangle_mesh_of_sphere([0 0 0],1,Refine_Level);
% deform!
VTX = [VTX(:,1) + 0.2*sin(2*pi*VTX(:,2)),...
       VTX(:,2) + 0.0*cos(2*pi*VTX(:,1)),...
       VTX(:,3)];
VTX = [VTX(:,1) + 0.0*sin(2*pi*VTX(:,2)),...
       VTX(:,2) + 0.0*cos(2*pi*VTX(:,1)),...
       VTX(:,3) + 0.2*sin(2*pi*VTX(:,1))];
Mesh = MeshTriangle(TRI,VTX, 'Gamma');
clear TRI VTX NEW_VTX;
% END: define sphere mesh

% define function spaces (i.e. the DoFmaps)
Vh_DoFmap = uint32(Mesh.ConnectivityList);

% assemble
tic
FEM = DEMO_mex_Heat_Eqn_On_A_Surface([],Mesh.Points,uint32(Mesh.ConnectivityList),[],[],Vh_DoFmap);
toc
Mass  = FEM(1).MAT;
Stiff = FEM(2).MAT;

% do some checks
disp('Summing the P1 mass matrix should be ~15.0024...  Error is:');
sum(Mass(:)) - 15.002433582852271

disp('Summing the P1 stiffness matrix should be close to 0.  Error is:');
sum(Stiff(:)) - 0

disp('Solve the Heat Equation On A Surface:');
Num_Steps = 30;
Soln = zeros(Mesh.Num_Vtx,Num_Steps+1);
x = Mesh.Points(:,1); y = Mesh.Points(:,2); z = Mesh.Points(:,3);
%min_x = min(x);
%Soln(:,1) = 1.0*exp(-(x-min_x).^2/0.03);
min_y = min(y);
Soln(:,1) = 1.0*exp(-(y-min_y).^2/0.01);
dt = 0.002; % time-step
A  = (1/dt) * Mass + Stiff;
disp('Begin Time-Stepping...');
for ii = 1:Num_Steps
    RHS = (1/dt)*(Mass * Soln(:,ii));
    Soln(:,ii+1) = A \ RHS;
end

% plot solution
disp('Plot Solution Of Heat Equation On A Surface:');
figure;
%title('Solution Of Heat Equation On A Surface','FontSize',12);
time_indices = [1 5 8 15 20 31];
for ind = 1:6
    subplot(2,3,ind);
    time_index = time_indices(ind);
    h1 = trisurf(Mesh.ConnectivityList,Mesh.Points(:,1),Mesh.Points(:,2),Mesh.Points(:,3),Soln(:,time_index));
    shading interp;
    colormap(jet);
    %light;
    lightangle(80,-20);
    lightangle(-40,40);
    %camlight left;
    %camlight right;
    lighting phong;
    %colorbar;
    caxis([0 1]);
    TITLE_STR = ['Time = ', num2str((time_index-1)*dt,'%1.3f')];
    title(TITLE_STR,'FontSize',10);
    set(gca,'FontSize',10);
    AX = [-2 2 -1 1 -2 2];
    axis(AX);
    axis equal;
    axis(AX);
    view([30,10]);
    
    if (ind==1)
        text(-1,-2,-3.8,'Heat Equation On A Surface','FontSize',14);
    end
    % only put in one colorbar
    if (ind==6)
        CB = colorbar('north');
        CB.Position(1) = 0.71; % SWW: MATLAB doesn't like this?
        CB.Position(2) = 0.51;
        %CB.Position(4) = 0.2;
        %CB.Position
        %[left, bottom, width, height]
        caxis([0 1]);
        %text(0.3,0.5,'Heat Equation')
    end
end

% sum up the heat!
Init_Heat = full(sum(Mass * Soln(:,1)));
Final_Heat = full(sum(Mass * Soln(:,end)));
% compute error in conservation of heat energy
Heat_Error = (Init_Heat - Final_Heat);

% VTX = Mesh.Points;
% TRI = Mesh.ConnectivityList;
% save('C:\TEMP\Heat_Eqn.mat','VTX','TRI','Soln','dt');

% error check
status = 0; % init
if (Heat_Error > 1e-13)
    disp(['Conservation of Heat Energy FAILED!']);
    status = 1;
end

end