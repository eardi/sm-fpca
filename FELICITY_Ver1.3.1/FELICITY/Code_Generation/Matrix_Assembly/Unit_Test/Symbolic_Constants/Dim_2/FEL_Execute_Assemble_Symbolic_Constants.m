function status = FEL_Execute_Assemble_Symbolic_Constants(mexName)
%FEL_Execute_Assemble_Symbolic_Constants
%
%   test FELICITY Auto-Generated Assembly Code

% Copyright (c) 01-18-2018,  Shawn W. Walker

% simple mesh
[Tri, Vtx] = bcc_triangle_mesh(3,3);
MT = MeshTriangle(Tri,Vtx,'Square');
clear Tri Vtx;

% Degree-of-Freedom map
P1_DoFmap = uint32(MT.ConnectivityList);

% set coefficient functions
u0_val = [MT.Points(:,1) + MT.Points(:,2), cos(MT.Points(:,2))]; % [x+y, cos(y)]
c0_val = pi*[-1, 1];

% assemble
tic
FEM = feval(mexName,[],MT.Points,P1_DoFmap,[],[],P1_DoFmap,c0_val,u0_val);
toc
mats = FEMatrixAccessor('Sym Const',FEM);

% extract the matrices
EF = mats.Get_Matrix('Elliptic_Form');
%EF

LA = mats.Get_Matrix('Lin_A');
%LA

LB = mats.Get_Matrix('Lin_B');
%LB

MA = mats.Get_Matrix('Mixed_Form_A');
%MA

MB = mats.Get_Matrix('Mixed_Form_B');
%MB

SF = mats.Get_Matrix('Simple_Form');
%SF

% define test and trial functions
x = MT.Points(:,1);
y = MT.Points(:,2);
v = [x, y];
u = [x+y, x+y];

% do some checks
ERR_VEC = zeros(5,1);
disp('Compute quantities...  Error is:');
ERR_VEC(1) = abs((v(:)' * EF * u(:)) - (pi/2));

ERR_VEC(2) = max(abs(LA - MA(:,1)));

ERR_VEC(3) = max(abs(LB - [1;0]));

ERR_VEC(4) = max(max(abs(MA - MB')));

ERR_VEC(5) = max(max(abs(SF - (-pi)*eye(2))));

ERR_VEC'

status = 0; % init
% error check
if (max(ERR_VEC) > 1e-13)
    disp(['Test Failed!']);
    status = 1;
end

end