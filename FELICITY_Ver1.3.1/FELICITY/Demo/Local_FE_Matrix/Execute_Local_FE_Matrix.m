function status = Execute_Local_FE_Matrix()
%Execute_Local_FE_Matrix
%
%   Demo code for Laplace 1-D.

% Copyright (c) 08-10-2017,  Shawn W. Walker

ERR_VEC = zeros(3,1);

% assemble mass and stiffness matrices on reference interval
VTX_1 = [0.0;
         1.0];
EDGE = uint32([1, 2]);
FEM_1D = DEMO_mex_MatAssem_Local_FE_Matrix_interval([],VTX_1,EDGE,[],[],EDGE);
M_1 = full(FEM_1D(1).MAT);
K_1 = full(FEM_1D(2).MAT);
M_1
K_1
disp('\lambda_{min}:');
min(eig(M_1))

% check against reference
REF_M_1 = 1*(1/3)*[1, 1/2;
                   1/2, 1];
REF_K_1 = 1*[ 1, -1;
             -1,  1];
ERR_VEC(1) = max( [ max(max(abs(REF_M_1 - M_1))), max(max(abs(REF_K_1 - K_1))) ] );

% assemble mass and stiffness matrices on reference triangle
VTX_2 = [0.0, 0.0;
         1.0, 0.0;
         0.0, 1.0];
TRI = uint32([1, 2, 3]);
FEM_2D = DEMO_mex_MatAssem_Local_FE_Matrix_triangle([],VTX_2,TRI,[],[],TRI);
M_2 = full(FEM_2D(1).MAT);
K_2 = full(FEM_2D(2).MAT);
M_2
K_2
disp('\lambda_{min}:');
min(eig(M_2))

% check against reference
REF_M_2 = (1/2)*(1/6)*[1, 1/2, 1/2;
                       1/2, 1, 1/2;
                       1/2, 1/2, 1];
REF_K_2 = (1/2)*[ 2, -1, -1;
                 -1,  1,  0;
                 -1,  0,  1];
ERR_VEC(2) = max( [ max(max(abs(REF_M_2 - M_2))), max(max(abs(REF_K_2 - K_2))) ] );

% assemble mass and stiffness matrices on reference tetrahedron
VTX_3 = [0.0, 0.0, 0.0;
         1.0, 0.0, 0.0;
         0.0, 1.0, 0.0;
         0.0, 0.0, 1.0];
TET = uint32([1, 2, 3, 4]);
FEM_3D = DEMO_mex_MatAssem_Local_FE_Matrix_tetrahedron([],VTX_3,TET,[],[],TET);
M_3 = full(FEM_3D(1).MAT);
K_3 = full(FEM_3D(2).MAT);
M_3
K_3
disp('\lambda_{min}:');
min(eig(M_3))

% check against reference
REF_M_3 = (1/6)*(1/10)*[1, 1/2, 1/2, 1/2;
                        1/2, 1, 1/2, 1/2;
                        1/2, 1/2, 1, 1/2;
                        1/2, 1/2, 1/2, 1];
REF_K_3 = (1/6)*[ 3, -1, -1, -1;
                 -1,  1,  0,  0;
                 -1,  0,  1,  0;
                 -1,  0,  0,  1];
ERR_VEC(3) = max( [ max(max(abs(REF_M_3 - M_3))), max(max(abs(REF_K_3 - K_3))) ] );

status = 0; % init
% compare to reference data
for ind = 1:length(ERR_VEC)
    if (ERR_VEC(ind) > 5e-16)
        disp(['Test Failed for Dimension = ', num2str(ind), '...']);
        status = 1;
    end
end
if (status==0)
    disp('Test passed!');
end

end