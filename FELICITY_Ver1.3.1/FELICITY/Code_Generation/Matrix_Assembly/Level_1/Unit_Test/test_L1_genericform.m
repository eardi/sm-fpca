function status = test_L1_genericform()
%test_L1_genericform
%
%   Test code for FELICITY class.

% Copyright (c) 05-20-2016,  Shawn W. Walker

status = 0;

% define some domains
Omega = Domain('triangle');
Sigma = Domain('interval') < Omega;
% define FEM spaces
V1 = Element(Sigma,lagrange_deg1_dim1,2);

v = Test(V1);
u = Trial(V1);
f = Coef(V1);

% test Bilinear
Mass_Matrix = Bilinear(V1,V1);
I1 = Integral(Sigma,f.val(1) * v.val' * u.val);
Mass_Matrix = Mass_Matrix.Add_Integral(I1);

if ~strcmp(Mass_Matrix.Integral.TestF.Name,'v')
    status = 1;
end
if ~strcmp(Mass_Matrix.Integral.TrialF.Name,'u')
    status = 1;
end
if ~strcmp(Mass_Matrix.Integral.CoefF.Name,'f')
    status = 1;
end

f = sym('f_v1_t1');
u1 = sym('u_v1_t1');
v1 = sym('v_v1_t1');
u2 = sym('u_v1_t2');
v2 = sym('v_v1_t2');
I_test = expand(f * (u1*v1 + u2*v2));
if ~(Mass_Matrix.Integral.Integrand==I_test)
    status = 1;
end
if ~strcmp(Mass_Matrix.Integral.Domain.Name,'Sigma')
    status = 1;
end
if ~strcmp(Mass_Matrix.Integral.Domain.Subset_Of,'Omega')
    status = 1;
end

% % now test Bilinear to detect if the integrand has the form of a *bilinear form*
% Test_B = Bilinear(V1,V1);
% I2 = Integral(Sigma,v.val' * u.val + v.val(1));
% Test_B = Test_B.Add_Integral(I2);

% % now test Linear to detect if the integrand has the form of a *linear form*
% Test_L = Linear(V1);
% I3 = Integral(Sigma,v.val(1) + 1);
% Test_L = Test_L.Add_Integral(I3);

%%%%%%%%%%%%%
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

end