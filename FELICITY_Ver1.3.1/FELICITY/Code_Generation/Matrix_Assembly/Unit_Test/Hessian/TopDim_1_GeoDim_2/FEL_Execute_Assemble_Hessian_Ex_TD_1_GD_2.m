function status = FEL_Execute_Assemble_Hessian_Ex_TD_1_GD_2(mexName)
%FEL_Execute_Assemble_Hessian_Ex_TD_1_GD_2
%
%   test FELICITY Auto-Generated Assembly Code

% Copyright (c) 08-13-2014,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

% BEGIN: define simple 1-D mesh
Num_P1_Nodes = 201; % best relative accuracy for 4th order stiffness matrix is ~1e-6
P1_Ind = (1:1:Num_P1_Nodes)';
P1_Mesh_DoFmap = uint32([P1_Ind(1:end-1,1), P1_Ind(2:end,1)]); % NOTE! unsigned integer
P1_Mesh_Nodes = linspace(0,1,Num_P1_Nodes)';
P1_Mesh_Nodes = [P1_Mesh_Nodes, 0*P1_Mesh_Nodes]; % set y-component to zero for now
Num_Edges = size(P1_Mesh_DoFmap,1);
Num_Current_DoF = max(P1_Mesh_DoFmap(:));
Extra_P2_Nodes = Num_Current_DoF + uint32((1:1:Num_Edges)');
P2_DoFmap = [P1_Mesh_DoFmap, Extra_P2_Nodes];
Mesh = MeshInterval(P1_Mesh_DoFmap,P1_Mesh_Nodes,'Sigma');
% END: define simple 1-D mesh

% define function spaces (i.e. the DoFmaps)
Ref_P2_Elem = ReferenceFiniteElement(lagrange_deg2_dim1);
Space = FiniteElementSpace('Scalar_P2',Ref_P2_Elem,Mesh,'Sigma');
Space = Space.Set_DoFmap(Mesh,P2_DoFmap);
P2_Mesh_Nodes  = Space.Get_DoF_Coord(Mesh);
P2_Mesh_DoFmap = P2_DoFmap;

% now define \Sigma to be a parabola
P2_Mesh_Nodes(:,2) = P2_Mesh_Nodes(:,1).^2;
P1_Mesh_Nodes = P2_Mesh_Nodes(1:Num_P1_Nodes,:);
Mesh = Mesh.Set_Points(P1_Mesh_Nodes);

% compute the arc-length at each mesh node
arc_length_func = @(t) asinh(2*t)/4 + t.*(t.^2 + 1/4).^(1/2);
arc_length_s    = arc_length_func(P2_Mesh_Nodes(:,1)) - arc_length_func(0);
Length_of_Sigma = max(arc_length_s);

% define coefficient functions
Scalar_Values = 0.01*sin(10*pi*arc_length_s);
Vector_Values = [(exp(arc_length_s)-1), exp(-arc_length_s)];

% assemble
tic
FEM = feval(str2func(mexName),[],P2_Mesh_Nodes,P2_Mesh_DoFmap,[],[],...
                              Space.DoFmap,Space.DoFmap,Scalar_Values,Vector_Values);
toc
RefFEMDataFileName = fullfile(Current_Dir,'FEL_Execute_Assemble_Hessian_Ex_TD_1_GD_2_REF_Data.mat');
% FEM_REF = FEM;
% save(RefFEMDataFileName,'FEM_REF');
load(RefFEMDataFileName);

% do some checks
disp('Summing the rows of the vector hessian matrix and dsds matrix should be the same!');
disp('        And close to zero.  Max error is:');
max(abs(sum(FEM(2).MAT,2))) - 0
max(abs(sum(FEM(3).MAT,2))) - 0

disp('Compute integrals of the hessian of known functions and compare to true values.  Relative error is:');
V1 = (pi^4 / 2) * (Length_of_Sigma - (1/(20*pi)) * sin(20*pi*Length_of_Sigma));
REL_ERR = (Scalar_Values' * FEM(3).MAT * Scalar_Values - V1) / V1;
REL_ERR

% Func = @(t) 4 * (1+4*t.^2).^(-5/2) .* (exp(2*arc_length_func(t)) + exp(-2*arc_length_func(t)));
% QQ = integral(Func,0,1,'AbsTol',1e-14);
% %QQ = 3.461895874779162

V1 = ( (exp(2*Length_of_Sigma) - exp(-2*Length_of_Sigma)) / 2 ) + 3.461895874779162;
REL_ERR = (Vector_Values(:)' * FEM(2).MAT * Vector_Values(:) - V1) / V1;
REL_ERR

disp('The Integral of (d^2/ds^2 0.01*sin(10*pi*s)) from 0 to 1 should be (pi/10) * (cos(10*pi*L) - 1).  Error is:')
FEM(1).MAT(1) - ((pi/10) * (cos(10*pi*Length_of_Sigma) - 1))

disp('The Integral of (d^2/ds^2 e^{-s}) from 0 to 1 should be (1 - e^{-L}).  Error is:')
FEM(1).MAT(2) - (1 - exp(-Length_of_Sigma))

status = 0; % init
% compare to reference data
ERRORS = zeros(length(FEM),1);
for ind = 1:length(FEM)
    ERRORS(ind) = max(abs(FEM(ind).MAT(:) - FEM_REF(ind).MAT(:)));
    if (ERRORS(ind) > 1e-6)
        disp(['Test Failed for FEM(', num2str(ind), ').MAT...']);
        status = 1;
    end
end

end