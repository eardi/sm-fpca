function status = test_L1_Integral()
%test_L1_Integral
%
%   Test code for FELICITY class.

% Copyright (c) 03-24-2018,  Shawn W. Walker

status = 0;

% define some domains
Omega = Domain('triangle');
Sigma = Domain('interval') < Omega;
% define FEM spaces
W1 = Element(Omega,lagrange_deg1_dim2,1);
V1 = Element(Sigma,lagrange_deg1_dim1,2);

w = Test(W1,Sigma); % need to restrict this function!
ww = Test(W1);
zz = Trial(W1);

v = Test(V1);
u = Trial(V1);
f = Coef(V1);

% just test Integral
I1 = Integral(Sigma,f.val(1) * v.val' * u.val);
I2 = Integral(Sigma,v.val' * [1; 1]);
I3 = Integral(Sigma,sum(u.grad' * w.grad));
I4 = Integral(Omega,sum(ww.grad' * zz.grad));
if ~strcmp(I1.TestF.Name,'v')
    status = 1;
end
if ~strcmp(I1.TrialF.Name,'u')
    status = 1;
end
if ~strcmp(I1.CoefF.Name,'f')
    status = 1;
end

w1 = sym('ww_v1_t1_grad1');
z1 = sym('zz_v1_t1_grad1');
w2 = sym('ww_v1_t1_grad2');
z2 = sym('zz_v1_t1_grad2');
I4_test = w1*z1 + w2*z2;
if ~(I4.Integrand==I4_test)
    status = 1;
end
if ~strcmp(I3.Domain.Name,'Sigma')
    status = 1;
end
if ~strcmp(I2.Domain.Subset_Of,'Omega')
    status = 1;
end

%%%%%%%%%%%%%
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

end