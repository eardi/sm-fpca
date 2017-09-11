function status = test_fematrix_accessor()
%test_fematrix_accessor
%
%   Test code for FELICITY class.

% Copyright (c) 04-27-2012,  Shawn W. Walker

% define a dummy set of finite element matrices
FEM.Type = 'Mass_Matrix';
FEM.MAT  = sprand(1000,1000,0.2);
FEM(2).Type = 'Stiff_Matrix';
FEM(2).MAT  = sprand(400,400,0.2);
FEM(3).Type = 'RHS';
FEM(3).MAT  = sprand(400,1,0.2);

FEM_Data = FEMatrixAccessor('test',FEM);
my_RHS   = FEM_Data.Get_Matrix('RHS');
my_stiff = FEM_Data.Get_Matrix('Stiff_Matrix');
my_mass  = FEM_Data.Get_Matrix('Mass_Matrix');

% run regression test
status = 0;
MASS_ERR = abs(my_mass(:) - FEM(1).MAT(:));
MASS_ERR = max(MASS_ERR);
STIFF_ERR = abs(my_stiff(:) - FEM(2).MAT(:));
STIFF_ERR = max(STIFF_ERR);
RHS_ERR = abs(my_RHS(:) - FEM(3).MAT(:));
RHS_ERR = max(RHS_ERR);
if MASS_ERR > 1e-15
    disp('Matrix Data Accessor test failed!  See ''test_fematrix_accessor''.');
    status = 1;
end
if STIFF_ERR > 1e-15
    disp('Matrix Data Accessor test failed!  See ''test_fematrix_accessor''.');
    status = 1;
end
if RHS_ERR > 1e-15
    disp('Matrix Data Accessor test failed!  See ''test_fematrix_accessor''.');
    status = 1;
end

end