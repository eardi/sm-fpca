function status = test_FEL_Finite_Element_Space_On_1D_Subdomain()
%test_FEL_Finite_Element_Space_On_1D_Subdomain
%
%   Demo code for FELICITY FiniteElementSpace class for a 1-D subdomain of a 2-D
%   mesh.

% Copyright (c) 05-17-2013,  Shawn W. Walker

% define a simple square mesh
Vtx = [0 0; 1 0; 1 1; 0 1; 0.5 0.5];
Tri = [1 2 5; 2 3 5; 3 4 5; 4 1 5];

% create a mesh object
Mesh = MeshTriangle(Tri,Vtx,'Square');

% define a subdomain to be one of the diagonals of the square
Mesh = Mesh.Append_Subdomain('1D','Diag',[1 5; 5 3]);

% declare reference element
P1_Elem = lagrange_deg1_dim1();
RE = ReferenceFiniteElement(P1_Elem,1); % 1 component

% declare a finite element space that is defined on 'Diag'
FES = FiniteElementSpace('P1',RE,Mesh,'Diag');
clear RE;

% set DoFmap
DFM = [1     2;
       2     3];
FES = FES.Set_DoFmap(Mesh,DFM);
clear DFM;

% look at the object
FES

% look at the DoFmap
FES.DoFmap

% get unique list of the DoFs
disp('List of DoFs:');
DoF_Indices = FES.Get_DoFs

% get the coordinates of the DoFs
disp('List of coordinates for DoFs:');
XC = FES.Get_DoF_Coord(Mesh)

% plot the mesh and DoFs
figure;
Mesh.Plot;
AX = [-0.05 1.05 -0.05 1.05];
axis(AX);
hold on;
for ii = 1:size(XC,1)
    plot(XC(ii,1),XC(ii,2),'kd','LineWidth',1.7);
    DoFstr = [num2str(ii)];
    text(XC(ii,1)+0.03,XC(ii,2)+0.0,DoFstr,'FontSize',16);
end
text(0.5,0.2,'T1');
text(0.8,0.5,'T2');
text(0.5,0.8,'T3');
text(0.2,0.5,'T4');
text(0.27,0.25,'E1');
text(0.77,0.75,'E2');
Mesh.Plot_Subdomain('Diag');
hold off;
axis equal;
axis(AX);
axis off;
title('P_1 DoFs of Finite Element Space (Numbered Diamonds)');

% begin unit test error checking
status = 0;
% reference data
XC_REF = [               0                         0
     5.000000000000000e-01     5.000000000000000e-01
     1.000000000000000e+00     1.000000000000000e+00];
%
if (max(max(abs(XC - XC_REF))) > 0)
    disp('Unit test failed!');
    status = 1;
end
% end unit testing

end