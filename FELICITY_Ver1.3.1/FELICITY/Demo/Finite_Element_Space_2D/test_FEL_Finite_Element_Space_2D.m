function status = test_FEL_Finite_Element_Space_2D()
%test_FEL_Finite_Element_Space_2D
%
%   Demo code for FELICITY FiniteElementSpace class (in 2-D).

% Copyright (c) 09-06-2012,  Shawn W. Walker

% define a simple square mesh
Vtx = [0 0; 1 0; 1 1; 0 1];
Tri = [1 2 3; 1 3 4];

% create a mesh object
Mesh = MeshTriangle(Tri,Vtx,'Square');
% define a 1D subdomain of the square mesh to be the outer boundary
Bdy_Edge = Mesh.freeBoundary;
Mesh = Mesh.Append_Subdomain('1D','Boundary',Bdy_Edge);

% define some more subdomains
Mesh = Mesh.Append_Subdomain('0D','Bottom Left Corner',[1]);
Mesh = Mesh.Append_Subdomain('0D','Bottom Right Corner',[2]);
Mesh = Mesh.Append_Subdomain('0D','Top Right Corner',[3]);
Mesh = Mesh.Append_Subdomain('0D','Top Left Corner',[4]);
Mesh = Mesh.Append_Subdomain('1D','Bottom Side',[1 2]);
Mesh = Mesh.Append_Subdomain('1D','Top Side',[3 4]);
Mesh = Mesh.Append_Subdomain('1D','Diag',[1 3]);
Mesh = Mesh.Append_Subdomain('2D','Bottom Tri',[1]);

% declare reference element
P2_Elem = lagrange_deg2_dim2();
RE = ReferenceFiniteElement(P2_Elem);

% declare a finite element space
FES = FiniteElementSpace('P2',RE,Mesh,[],2); % 2 components
clear RE;

% set DoFmap
DFM = [1     2     3     8     6     5;
       1     3     4     9     7     6];
FES = FES.Set_DoFmap(Mesh,DFM);
clear DFM;

% look at the object
FES

% look at the DoFmap
FES.DoFmap

% get unique list of the (1st component) DoFs
disp('List of (1st component) DoFs:');
DoF_Indices = FES.Get_DoFs

% get the coordinates of the DoFs
disp('List of coordinates for (1st component) DoFs:');
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
    text(XC(ii,1)+0.03,XC(ii,2)+0.02,DoFstr,'FontSize',16);
end
text(0.75,0.25,'T1');
text(0.25,0.75,'T2');
hold off;
axis equal;
axis(AX);
axis off;
title('P_2 Degrees-of-Freedom (Numbered Diamonds)');

% get the 2nd component DoF indices
FES.Get_DoFs(2)

% get list of all the (tensor component) DoFs
FES.Get_DoFs('all')

% get list of the (1st component) DoFs on the Boundary
Bdy_DoFs = FES.Get_DoFs_On_Subdomain(Mesh,'Boundary')

% get list of all the (tensor component) DoFs on the Boundary
FES.Get_DoFs_On_Subdomain(Mesh,'Boundary','all')

% get the coordinates of the Boundary DoFs
XC(Bdy_DoFs,:)

% extract DoFs for each subdomain
for ii = 1:length(Mesh.Subdomain)
    SubName = Mesh.Subdomain(ii).Name;
    disp([SubName, ':']);
    FES.Get_DoFs_On_Subdomain(Mesh,SubName)
end

disp('Fix the DoFs on ''Bottom Side'' and ''Top Side''.');
FES = FES.Append_Fixed_Subdomain(Mesh,'Bottom Side');
FES = FES.Append_Fixed_Subdomain(Mesh,'Top Side');
FES

disp('List of Fixed DoFs:');
FES.Get_Fixed_DoFs(Mesh,'all')
%FES.Get_Fixed_DoFs(Mesh,2)
disp('List of Free DoFs:');
FES.Get_Free_DoFs(Mesh,'all')


% begin unit test error checking
status = 0;
% reference data
XC_REF = [               0                         0;
     1.000000000000000e+00                         0;
     1.000000000000000e+00     1.000000000000000e+00;
                         0     1.000000000000000e+00;
     5.000000000000000e-01                         0;
     5.000000000000000e-01     5.000000000000000e-01;
                         0     5.000000000000000e-01;
     1.000000000000000e+00     5.000000000000000e-01;
     5.000000000000000e-01     1.000000000000000e+00];
%
All_DoFs_REF = [...
     1    10;
     2    11;
     3    12;
     4    13;
     5    14;
     6    15;
     7    16;
     8    17;
     9    18];
%
Bdy_DoFs_REF = [...
     1    10;
     2    11;
     3    12;
     4    13;
     5    14;
     7    16;
     8    17;
     9    18];
%
Fixed_DoFs_REF = [...
     1;
     2;
     3;
     4;
     5;
     9;
    10;
    11;
    12;
    13;
    14;
    18];
Free_DoFs_REF = [...
     6;
     7;
     8;
    15;
    16;
    17];
%
if (max(max(abs(XC - XC_REF))) > 0)
    disp('Unit test failed!');
    status = 1;
end
if (max(max(abs(FES.Get_DoFs('all') - All_DoFs_REF))) > 0)
    disp('Unit test failed!');
    status = 1;
end
if (max(max(abs(FES.Get_DoFs_On_Subdomain(Mesh,'Boundary','all') - Bdy_DoFs_REF))) > 0)
    disp('Unit test failed!');
    status = 1;
end
if (max(max(abs(FES.Get_Fixed_DoFs(Mesh,'all') - Fixed_DoFs_REF))) > 0)
    disp('Unit test failed!');
    status = 1;
end
if (max(max(abs(FES.Get_Free_DoFs(Mesh,'all') - Free_DoFs_REF))) > 0)
    disp('Unit test failed!');
    status = 1;
end
% end unit testing

FES = FES.Set_Fixed_Subdomains(Mesh,{});

end